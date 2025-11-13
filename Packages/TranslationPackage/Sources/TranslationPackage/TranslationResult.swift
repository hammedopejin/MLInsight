//
//  TranslationResult.swift
//  TranslationPackage
//
//  Created by blackmagic on 11/13/25.
//

import Foundation

public struct TranslationResult: Sendable {
    public let originalText: String
    public let translatedText: String
    public let sourceLanguage: String
    public let duration: TimeInterval

    public init(
        originalText: String,
        translatedText: String,
        sourceLanguage: String,
        duration: TimeInterval
    ) {
        self.originalText = originalText
        self.translatedText = translatedText
        self.sourceLanguage = sourceLanguage
        self.duration = duration
    }
}
