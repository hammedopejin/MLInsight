import Foundation
import AVFoundation

@MainActor
public final class AudioPlaybackCoordinator: NSObject, ObservableObject, @preconcurrency AVAudioPlayerDelegate {
    @Published public var isPlaying = false
    private var player: AVAudioPlayer?

    public func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
            isPlaying = true
        } catch {
            print("Playback failed: \(error.localizedDescription)")
            isPlaying = false
        }
    }

    public func stop() {
        player?.stop()
        isPlaying = false
    }

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
