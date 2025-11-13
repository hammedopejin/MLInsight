//
//  UnifiedReport.swift
//  TranslationPackage
//
//  Created by blackmagic on 11/13/25.
//

import Foundation

public struct UnifiedReport: Sendable {
    public let originalText: String
    public let detectedLanguage: String
    public let translatedText: String
    public let translationDuration: TimeInterval
    public let confidence: Double
    public let benchmark: [BenchmarkResult]

    public init(
        originalText: String,
        detectedLanguage: String,
        translatedText: String,
        translationDuration: TimeInterval,
        confidence: Double,
        benchmark: [BenchmarkResult]
    ) {
        self.originalText = originalText
        self.detectedLanguage = detectedLanguage
        self.translatedText = translatedText
        self.translationDuration = translationDuration
        self.confidence = confidence
        self.benchmark = benchmark
    }
}
