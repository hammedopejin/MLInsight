//
//  UnifiedAnalyzerViewModel.swift
//  MLInsight
//
//  Created by blackmagic on 11/13/25.
//

import Foundation
import TranslationPackage

@MainActor
public final class UnifiedAnalyzerViewModel: ObservableObject {
    @Published public var report: UnifiedReport?
    @Published public var error: TranslationError?

    private let detector = LanguageDetector()
    private let translator = TextTranslator()
    private let benchmark = TranslationBenchmark()

    public init() {}

    public func analyze(text: String, shouldTranslate: Bool) async {
        benchmark.reset()
        report = nil
        error = nil

        do {
            benchmark.start(label: "language-detection")
            let detection = try detector.detectLanguage(for: text)
            benchmark.stop(label: "language-detection")

            var translatedText = text
            var translationDuration: TimeInterval = 0

            if shouldTranslate {
                benchmark.start(label: "translation")
                let translation = try await translator.translateToEnglish(
                    text: text,
                    sourceLanguage: detection.isoCode
                )
                benchmark.stop(label: "translation")
                translatedText = translation.translatedText
                translationDuration = translation.duration
            }

            report = UnifiedReport(
                originalText: text,
                detectedLanguage: detection.localizedName,
                translatedText: translatedText,
                translationDuration: translationDuration,
                confidence: detection.confidence,
                benchmark: benchmark.allResults()
            )
        } catch let thrownError as TranslationError {
            self.error = thrownError
        } catch {
            self.error = .translationFailed
        }
    }
}
