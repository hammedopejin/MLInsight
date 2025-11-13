import Foundation

public enum AudioModelError: Error, LocalizedError {
    case transcriptionFailed
    case classificationFailed
    case logWriteFailed
    case permissionDenied
    case unsupportedFormat
    case modelNotLoaded
    case initializationFailure
    case invalidAudio
    case invalidAudioURL
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .transcriptionFailed:
            return "Speech transcription failed."
        case .classificationFailed:
            return "Sound classification failed."
        case .logWriteFailed:
            return "Failed to write analysis log."
        case .permissionDenied:
            return "Permission denied for audio access."
        case .unsupportedFormat:
            return "Unsupported audio format."
        case .modelNotLoaded:
            return "The model has not been loaded yet."
        case .initializationFailure:
            return "Failed to initialize the sound classification model."
        case .invalidAudio:
            return "The audio could not be processed."
        case .invalidAudioURL:
            return "The provided audio URL is invalid or could not be opened."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
