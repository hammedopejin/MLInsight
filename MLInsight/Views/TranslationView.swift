//
//  TranslationView.swift
//  MLInsight
//
//  Created by blackmagic on 11/13/25.
//

import SwiftUI

struct TranslationView: View {
    @StateObject private var viewModel = UnifiedAnalyzerViewModel()
    @State private var inputText: String = ""
    @State private var shouldTranslate = true
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enter text to analyze:")
                        .font(.headline)

                    TextEditor(text: $inputText)
                        .focused($isFocused)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                    Toggle("Translate to English", isOn: $shouldTranslate)
                        .padding(.vertical)

                    Button("Analyze") {
                        Task {
                            await viewModel.analyze(text: inputText, shouldTranslate: shouldTranslate)
                            isFocused = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }

                    if let report = viewModel.report {
                        Group {
                            Text("Detected Language:")
                                .font(.headline)
                            Text(report.detectedLanguage)
                                .font(.body)

                            if shouldTranslate {
                                Text("Translated Text:")
                                    .font(.headline)
                                Text(report.translatedText)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            Text("Confidence: \(String(format: "%.2f", report.confidence))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Translation Duration: \(String(format: "%.3f", report.translationDuration))s")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if !report.benchmark.isEmpty {
                                Text("Benchmark:")
                                    .font(.headline)
                                ForEach(report.benchmark, id: \.label) { result in
                                    HStack {
                                        Text(result.label)
                                        Spacer()
                                        Text(String(format: "%.3f s", result.duration))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: 600)
            }
            .navigationTitle("Text Translator")
        }
    }
}
