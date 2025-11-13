# MLInsight

MLInsight is a modular, SwiftUI-powered iOS app that performs real-time image classification, sentiment analysis, audio transcription/classification, and multilingual text translation. Built with MVVM and Clean Architecture, each ML task is encapsulated in its own Swift Package for maximum modularity, testability, and reproducibility.

---

## Overview

MLInsight demonstrates how to integrate multiple Core ML and NLP models into a unified iOS experience using Swift Package Manager. It supports asynchronous inference, benchmark logging, error handling, and clean UI presentation. The app is designed for professional deployment, technical interviews, and portfolio showcasing.

---

## Tech Stack

- Swift 5.9 / Swift 6 (actor-safe)
- SwiftUI
- Core ML
- NaturalLanguage
- SoundAnalysis
- Speech
- AVFoundation
- Swift Package Manager
- XCTest

---

## Architecture

- MVVM + Clean Architecture
- Swift Packages for each ML task
- Protocol abstraction for model interfaces
- Actor-safe concurrency with `@MainActor` and `Sendable`
- Benchmarking utilities for model load and inference
- Mock classifiers for CI and test isolation
- Modular error taxonomy across packages

---

## Project Structure

```
MLInsight/
├── MLInsight.xcodeproj              # Xcode project
├── README.md                        # Project documentation

├── MLInsight/                       # App target
│   ├── Views/
│   │   ├── MobileNetView.swift
│   │   ├── SentimentView.swift
│   │   ├── AudioAnalyzerView.swift
│   │   ├── TranslationView.swift
│   │   └── RootView.swift
│   ├── ViewModels/
│   │   ├── MobileNetViewModel.swift
│   │   ├── AudioAnalyzerViewModel.swift
│   │   ├── UnifiedAnalyzerViewModel.swift
│   │   └── SentimentAnalyzer.swift
│   ├── Assets/
│   │   └── SampleImages/
│   └── Info.plist

├── MLInsightTests/
│   ├── ImageClassifierTests.swift
│   ├── SentimentAnalyzerTests.swift
│   ├── TextTranslatorTests.swift
│   ├── AudioLogWriterTests.swift
│   └── Info.plist

├── Packages/
│   ├── MobileNetV2Package/
│   │   └── Sources/
│   │       └── MobileNetV2Package/
│   │           ├── MobileNetClassifier.swift
│   │           ├── ModelError.swift
│   │           ├── Benchmark.swift
│   │           └── MockImageClassifier.swift
│   ├── SentimentAnalysisPackage/
│   │   └── Sources/
│   │       └── SentimentAnalysisPackage/
│   │           ├── SentimentAnalyzer.swift
│   │           └── SentimentResult.swift
│   ├── AudioAnalysisPackage/
│   │   └── Sources/
│   │       └── AudioAnalysisPackage/
│   │           ├── SoundClassifier.swift
│   │           ├── SpeechTranscriber.swift
│   │           ├── AudioLogWriter.swift
│   │           ├── AudioModelError.swift
│   │           └── SoundPrediction.swift
│   └── TranslationPackage/
│       └── Sources/
│           └── TranslationPackage/
│               ├── TextTranslator.swift
│               ├── TranslationResult.swift
│               ├── TranslationError.swift
│               ├── LanguageDetector.swift
│               └── TranslationBenchmark.swift
```

---

## Features

- **Image Classification**: MobileNetV2 via Core ML
- **Text Sentiment Analysis**: NLTagger with async support
- **Audio Transcription**: SFSpeechRecognizer with live recording
- **Sound Classification**: Ambient audio labeling via SoundAnalysis
- **Text Translation**: Language detection + English translation pipeline
- **Benchmarking**: Duration tracking for each ML stage
- **Logging**: JSON logs of predictions and transcripts
- **UI**: SwiftUI tabs for each analyzer with live feedback
- **Error Handling**: Typed enums across packages
- **Testing**: Mock classifiers and ≥60% unit test coverage
- **Concurrency**: Fully actor-safe with `Sendable` compliance

---

## Example Usage

```swift
let classifier = MobileNetClassifier()
try classifier.loadModel()
classifier.predict(buffer: somePixelBuffer) { result in
    print(result.label)
}

let sentiment = await SentimentAnalyzer().analyzeAsync(text: "I love this app!")
print(sentiment.category) // .positive

let soundClassifier = SoundClassifier()
let predictions = try await soundClassifier.classifyAudio(from: audioURL)

let transcriber = SpeechTranscriber()
let transcript = try await transcriber.transcribeAudio(from: audioURL)

try AudioLogWriter().saveLog(predictions: predictions, transcription: transcript)

let translator = TextTranslator()
let result = try await translator.translateToEnglish(text: "Bonjour", sourceLanguage: "fr")
print(result.translatedText) // "Hello"
```

---

## Testing

- `XCTest` coverage across all packages
- `MockImageClassifier` for deterministic CI tests
- `TextTranslatorTests` for translation pipeline
- `AudioLogWriterTests` for file I/O and JSON validation
- Run tests via ⌘U or `xcrun xccov`
- Coverage ≥ 60%

---

## What I Learned

- Modularizing ML pipelines with Swift Packages
- Actor-safe concurrency in Swift 6
- Benchmarking and profiling ML inference
- Building testable, reproducible ML apps
- Managing permissions for microphone and speech
- Designing clean, scalable UI with SwiftUI
- Structuring error taxonomies across modules

