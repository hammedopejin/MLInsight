//
//  SentimentAnalyzer.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import Foundation
import NaturalLanguage
import SentimentAnalysisPackage

public struct SentimentAnalyzer {
    public init() {}

    public func analyze(text: String, completion: @escaping (SentimentResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result: SentimentResult

            if #available(iOS 15.0, *) {
                let tagger = NLTagger(tagSchemes: [.sentimentScore])
                tagger.string = text

                let (scoreTag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
                let score = Double(scoreTag?.rawValue ?? "0") ?? 0.0

                let category: SentimentCategory
                switch score {
                case let x where x > 0.25:
                    category = .positive
                case let x where x < -0.25:
                    category = .negative
                default:
                    category = .neutral
                }

                result = SentimentResult(category: category, score: score)
            } else {
                result = SentimentResult(category: .neutral, score: 0.0)
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    public func analyzeAsync(text: String) async -> SentimentResult {
        await withCheckedContinuation { continuation in
            analyze(text: text) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
