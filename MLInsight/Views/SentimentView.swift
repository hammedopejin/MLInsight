//
//  SentimentView..swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import SwiftUI
import SentimentAnalysisPackage

struct SentimentView: View {
    @State private var inputText: String = ""
    @State private var result: SentimentResult?
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool

    private let analyzer = SentimentAnalyzer()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sentiment Analyzer")
                .font(.title2)
                .bold()

            TextEditor(text: $inputText)
                .padding(8)
                .frame(minHeight: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .focused($isFocused)
                .background(Color(.systemBackground))
                .cornerRadius(8)

            Button("Analyze Sentiment") {
                runAnalysis()
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            if let result = result {
                VStack(spacing: 8) {
                    Text("Sentiment: \(result.category.rawValue.capitalized)")
                        .font(.headline)
                    Text(String(format: "Score: %.2f", result.score))
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: .constant(errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    errorMessage = nil
                }
            )
        }
    }

    private func runAnalysis() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter some text."
            return
        }

        Task {
            result = await analyzer.analyzeAsync(text: inputText)
            isFocused = false
        }
    }
}

