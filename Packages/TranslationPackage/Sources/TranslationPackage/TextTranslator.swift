//
//  TextTranslator.swift
//  TranslationPackage
//
//  Created by blackmagic on 11/13/25.
//

import Foundation
import TranslationPackage

@available(iOS 13.0, *)
public final class TextTranslator {
    public init() {}

    public func translateToEnglish(text: String, sourceLanguage: String? = nil) async throws -> TranslationResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw TranslationError.emptyInput
        }

        try await Task.sleep(nanoseconds: 1_000_000)

        if trimmed.unicodeScalars.contains(where: { $0.value > 0x13000 }) {
            throw TranslationError.translationFailed
        }

        return TranslationResult(
            originalText: trimmed,
            translatedText: "[Translated] \(trimmed)",
            sourceLanguage: sourceLanguage ?? "und",
            duration: Date().timeIntervalSince1970
        )
    }
}
