import Foundation
import AVFoundation

@MainActor
public final class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var recorder: AVAudioRecorder?
    private var completion: ((Result<URL, Error>) -> Void)?

    public override init() {
        super.init()
    }

    public func startRecording() async throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        print("Requesting microphone permission...")
        let granted = await withCheckedContinuation { continuation in
            session.requestRecordPermission { granted in
                print("Permission callback received: \(granted)")
                continuation.resume(returning: granted)
            }
        }

        let url = Self.recordingURL
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.delegate = self
        recorder?.record()

        let isRecording = recorder?.isRecording ?? false
        print("Recorder isRecording: \(isRecording)")

        if !granted && !isRecording {
            throw AudioModelError.permissionDenied
        }

        print("Recording started at: \(url.path)")
    }

    public func stopRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        print("Stopping recording. Recorder is nil? \(recorder == nil)")
        self.completion = completion
        recorder?.stop()
    }

    nonisolated public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let result: Result<URL, Error> = flag
            ? .success(recorder.url)
            : .failure(AudioModelError.unknown(NSError(domain: "Recording failed", code: -1)))

        DispatchQueue.main.async {
            self.completion?(result)
        }
    }

    public static var recordingURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
    }
}
