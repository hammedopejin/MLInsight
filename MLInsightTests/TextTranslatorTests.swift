//
//  TextTranslatorTests.swift
//  MLInsight
//
//  Created by blackmagic on 11/13/25.
//

import XCTest
@testable import TranslationPackage
@testable import MLInsight

final class TextTranslatorTests: XCTestCase {

    func testTranslatesSpanishToEnglish() async throws {
        let translator = TextTranslator()
        let result = try await translator.translateToEnglish(text: "Hola, ¿cómo estás?", sourceLanguage: "es")

        XCTAssertEqual(result.originalText, "Hola, ¿cómo estás?")
        XCTAssertEqual(result.translatedText, "[Translated] Hola, ¿cómo estás?")
        XCTAssertEqual(result.sourceLanguage, "es")
        XCTAssertTrue(result.duration >= 0)
    }

    func testThrowsOnEmptyInput() async throws {
        let translator = TextTranslator()
        do {
            _ = try await translator.translateToEnglish(text: "")
            XCTFail("Expected TranslationError.emptyInput but no error was thrown")
        } catch let error as TranslationError {
            XCTAssertEqual(error, .emptyInput)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testHandlesUnsupportedLanguage() async throws {
        let translator = TextTranslator()
        do {
            _ = try await translator.translateToEnglish(text: "𓀀𓂀𓃰𓆣𓇋𓏏𓐍", sourceLanguage: "und")
            XCTFail("Expected TranslationError.translationFailed but no error was thrown")
        } catch let error as TranslationError {
            XCTAssertEqual(error, .translationFailed)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
