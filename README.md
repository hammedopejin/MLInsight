---

# MLInsight

MLInsight is a modular, SwiftUI-powered iOS app that performs real-time image classification, text sentiment analysis, and audio transcription/classification using Core ML, Natural Language, and SoundAnalysis frameworks. It’s built with MVVM and Clean Architecture principles, and each model is wrapped in its own Swift Package for maximum modularity, testability, and reproducibility.

---

## Overview

This project demonstrates how to integrate multiple Core ML models into an iOS app using Swift Package Manager, run inferences asynchronously, benchmark performance, and display results in a responsive UI. It includes unit tests, mocking, error handling, and documentation suitable for professional deployment or portfolio presentation.

---

## Tech Stack

- Swift 5.9
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
- Protocol abstraction for model interfaces
- Swift Packages for each ML model
- Asynchronous inference with Task and DispatchQueue
- Platform-safe boundaries using availability annotations
- Benchmarking utilities for model load and prediction
- Mock classifiers for CI and test isolation

## Project Structure

```text
MLInsight/
├── MLInsight.xcodeproj              # Xcode project file
├── README.md                        # Project documentation

├── MLInsight/                       # App target source code
│   ├── Views/
│   │   ├── SentimentView.swift
│   │   ├── ImageClassifierView.swift
│   │   └── AudioAnalyzerView.swift
│   │
│   ├── ViewModel/
│   │   ├── SentimentAnalyzer.swift
│   │   └── MobileNetClassifier.swift   # (deleted, now in package)
│   │
│   ├── Assets/
│   │   └── SampleImages/              # ML input samples
│   │
│   └── Info.plist                     # App target permissions and metadata

├── MLInsightTests/                  # Auto-created test target
│   ├── ImageClassifierTests.swift
│   ├── SentimentAnalyzerTests.swift
│   ├── MockImageClassifierTests.swift
│   └── Info.plist

├── Packages/                        # Swift Packages
│   ├── MobileNetV2Package/
│   │   ├── Sources/
│   │   │   └── MobileNetV2Package/
│   │   │       ├── MobileNetClassifier.swift
│   │   │       ├── ModelError.swift
│   │   │       └── Benchmark.swift
│   │   │       └── MockImageClassifier.swift
│   │
│   ├── SentimentAnalysisPackage/
│   │   ├── Sources/
│   │   │   └── SentimentAnalysisPackage/
│   │   │       ├── SentimentResult.swift
│   │   │       └── SentimentAnalyzer.swift
│   │   └── Tests/
│   │       └── SentimentAnalysisPackageTests/
│   │           └── SentimentAnalysisPackageTests.swift
│   │
│   └── AudioAnalysisPackage/
│       ├── Sources/
│       │   └── AudioAnalysisPackage/
│       │       ├── SoundClassifier.swift
│       │       ├── SpeechTranscriber.swift
│       │       ├── AudioLogWriter.swift
│       │       ├── AudioModelError.swift
│       │       └── SoundPrediction.swift
│       └── Tests/
│           └── AudioAnalysisPackageTests/
│               └── AudioLogWriterTests.swift

---

## Features

- Image classification using MobileNetV2
- Text sentiment analysis using NLTagger
- Speech-to-text transcription using `SFSpeechRecognizer`
- Ambient sound classification using `SoundClassifier`
- Audio recording and playback with live progress UI
- JSON logging of predictions and transcription
- Asynchronous inference for all models
- Modular Swift Packages for each ML task
- Protocol-based abstraction for testability
- Benchmarking for model load and prediction latency
- Mock classifiers for CI and preview builds
- Clear error handling for invalid input and model state
- Unit test coverage ≥ 60%
- Graceful handling of unsupported image formats

---

## Example Usage

let classifier = MobileNetClassifier()
try classifier.loadModel()
classifier.predict(buffer: somePixelBuffer) { result in
    // handle label
}

let sentiment = await SentimentAnalyzer().analyzeAsync(text: "I love this app!")
print(sentiment.category) // .positive
print(sentiment.score)    // 0.87

let soundClassifier = SoundClassifier()
let predictions = try await soundClassifier.classifyAudio(from: audioURL)

let transcriber = SpeechTranscriber()
let transcript = try await transcriber.transcribeAudio(from: audioURL)

try AudioLogWriter().saveLog(predictions: predictions, transcription: transcript)

---

## Testing

- XCTest coverage for all packages and app-level wrappers
- MockImageClassifier for fast, deterministic tests
- Benchmark logs for performance tracking
- Coverage ≥ 60% (run ⌘U in Xcode or use `xcrun xccov`)
- Unit tests for `AudioLogWriter`, `SoundClassifier`, and `SpeechTranscriber`

---

## What I Learned

- How to modularize ML logic using Swift Packages
- How to run Core ML, NLTagger, and SoundAnalysis asynchronously
- How to structure an iOS app using MVVM and Clean Architecture
- How to benchmark and mock ML pipelines
- How to handle platform availability and input validation
- How to manage microphone and speech permissions in iOS

---
