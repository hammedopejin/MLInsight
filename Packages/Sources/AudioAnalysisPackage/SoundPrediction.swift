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

// SoundAnalysis results are typically sent from an internal queue,
// so marking this as Sendable helps manage concurrency in the context of the delegate.
extension SoundPrediction: Sendable {}
