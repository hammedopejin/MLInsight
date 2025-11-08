//
//  AudioAnalyzerView.swift
//  MLInsight
//
//  Created by blackmagic on 11/7/25.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation
import AudioAnalysisPackage

struct AudioAnalyzerView: View {
    @State private var predictions: [SoundPrediction] = []
    @State private var transcription: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedFileURL: URL?
    @State private var documentPickerDelegate: DocumentPickerDelegate?
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var recordingTimer: Timer?
    @StateObject private var playback = AudioPlaybackCoordinator()
    @State private var logPreview: String?

    private let classifier = SoundClassifier()
    private let transcriber = SpeechTranscriber()
    private let logger = AudioLogWriter()
    private let recorder = AudioRecorder()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let selectedFileURL = selectedFileURL {
                        Text("Selected: \(selectedFileURL.lastPathComponent)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        Button("Select Audio File") {
                            selectAudioFile()
                        }

                        Button(isRecording ? "Stop Recording" : "Record Audio") {
                            toggleRecording()
                        }
                        .tint(isRecording ? .red : .blue)

                        Button(playback.isPlaying ? "Stop Playback" : "Play Audio") {
                            togglePlayback()
                        }
                        .disabled(selectedFileURL == nil)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)

                    if isRecording {
                        Text("Recording Duration: \(formattedDuration())")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    if isLoading {
                        ProgressView("Analyzing...")
                    } else if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else {
                        if !transcription.isEmpty {
                            Text("Transcription:")
                                .font(.headline)
                            Text(transcription)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        if !predictions.isEmpty {
                            Text("Top Predictions:")
                                .font(.headline)
                            ForEach(predictions, id: \.label) { prediction in
                                HStack {
                                    Text(prediction.label)
                                    Spacer()
                                    Text(String(format: "%.2f%%", prediction.confidence * 100))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                            }
                        }

                        Button("Preview Saved Log") {
                            previewLog()
                        }
                        .buttonStyle(.bordered)

                        if let logPreview = logPreview {
                            Text("Saved Log:")
                                .font(.headline)
                            Text(logPreview)
                                .font(.caption)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: 600)
            }
            .navigationTitle("Audio Analyzer")
        }
    }

    private func selectAudioFile() {
        let supportedTypes: [UTType] = [.audio]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.allowsMultipleSelection = false

        let delegate = DocumentPickerDelegate { url in
            self.selectedFileURL = url
            analyzeAudio(at: url)
        }
        documentPickerDelegate = delegate
        picker.delegate = delegate

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(picker, animated: true)
        }
    }

    private func toggleRecording() {
        if isRecording {
            recorder.stopRecording { result in
                stopRecordingTimer()
                isRecording = false
                switch result {
                case .success(let url):
                    selectedFileURL = url
                    errorMessage = nil
                    analyzeAudio(at: url)
                case .failure(let error):
                    if case AudioModelError.permissionDenied = error {
                        let path = AudioRecorder.recordingURL.path
                        if FileManager.default.fileExists(atPath: path) {
                            print("Recording file exists — suppressing permission error")
                            errorMessage = nil
                        } else {
                            errorMessage = error.localizedDescription
                        }
                    } else {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        } else {
            Task {
                do {
                    try await recorder.startRecording()
                    isRecording = true
                    errorMessage = nil
                    startRecordingTimer()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func startRecordingTimer() {
        recordingDuration = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1
        }
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }

    private func formattedDuration() -> String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func togglePlayback() {
        guard let url = selectedFileURL else { return }

        if playback.isPlaying {
            playback.stop()
        } else {
            playback.play(url: url)
        }
    }

    private func analyzeAudio(at url: URL) {
        isLoading = true
        predictions = []
        transcription = ""
        errorMessage = nil
        logPreview = nil

        Task {
            do {
                async let classified = classifier.classifyAudio(from: url)
                async let transcribed = transcriber.transcribeAudio(from: url)

                let (preds, transcript) = try await (classified, transcribed)
                predictions = preds
                transcription = transcript

                try logger.saveLog(predictions: preds, transcription: transcript)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func previewLog() {
        do {
            let url = try logger.logFileURL()
            let data = try Data(contentsOf: url)
            logPreview = String(data: data, encoding: .utf8)
        } catch {
            errorMessage = "Failed to load log: \(error.localizedDescription)"
        }
    }
}

final class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    private let onPick: (URL) -> Void

    init(onPick: @escaping (URL) -> Void) {
        self.onPick = onPick
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        onPick(url)
    }
}
