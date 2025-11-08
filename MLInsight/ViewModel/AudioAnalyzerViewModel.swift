//
//  AudioAnalyzerViewModel.swift
//  MLInsight
//
//  Created by blackmagic on 11/7/25.
//

import Foundation
import Combine
import AVFoundation

@MainActor
final class AudioAnalyzerViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var recordingDuration: TimeInterval = 0

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    func startRecording() throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.record()

        isRecording = true
        recordingDuration = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil

        timer?.invalidate()
        timer = nil

        isRecording = false
    }

    func formattedDuration() -> String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
