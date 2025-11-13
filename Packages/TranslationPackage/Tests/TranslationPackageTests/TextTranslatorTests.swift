//
//  TextTranslatorTests.swift
//  TranslationPackageTests
//
//  Created by blackmagic on 11/13/25.
//

import Testing
@testable import TranslationPackage

@Test func translatesSpanishToEnglish() async throws {
    let translator = TextTranslator()
    let result = try await translator.translateToEnglish(text: "Hola, ¿cómo estás?", sourceLanguage: "es")

    #expect(result.originalText == "Hola, ¿cómo estás?")
    #expect(result.translatedText == "[Translated] Hola, ¿cómo estás?")
    #expect(result.sourceLanguage == "es")
    #expect(result.duration >= 0)
}

@Test func throwsOnEmptyInput() async throws {
    let translator = TextTranslator()
    #expect(throws: TranslationError.emptyInput) {
        _ = try await translator.translateToEnglish(text: "")
    }
}

@Test func handlesUnsupportedLanguage() async throws {
    let translator = TextTranslator()
    #expect(throws: TranslationError.translationFailed) {
        _ = try await translator.translateToEnglish(text: "𓀀𓂀𓃰𓆣𓇋𓏏𓐍", sourceLanguage: "und")
    }
}
