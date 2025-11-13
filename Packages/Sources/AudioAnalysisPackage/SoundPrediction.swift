import Foundation

/// Represents a single sound prediction with a label and confidence score.
public struct SoundPrediction: Codable, Equatable, Sendable {
    public let label: String
    public let confidence: Double

    public init(label: String, confidence: Double) {
        self.label = label
        self.confidence = confidence
    }
}
