---

# MLInsight

MLInsight is a modular, SwiftUI-powered iOS app that performs real-time image classification and text sentiment analysis using Core ML and Apple’s Natural Language framework. It’s built with MVVM and Clean Architecture principles, and each model is wrapped in its own Swift Package for maximum modularity, testability, and reproducibility.

---

## Overview

This project demonstrates how to integrate multiple Core ML models into an iOS app using Swift Package Manager, run inferences asynchronously, benchmark performance, and display results in a responsive UI. It includes unit tests, mocking, error handling, and documentation suitable for professional deployment or portfolio presentation.

---

## Tech Stack

- Swift 5.9
- SwiftUI
- Core ML
- NaturalLanguage
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

---

## Project Structure

```
MLInsight/
├── MLInsight.xcodeproj              # Xcode project file
├── README.md                        # Project documentation

├── MLInsight/                       # App target source code
│   ├── Views/
│   │   ├── SentimentView.swift
│   │   └── ImageClassifierView.swift
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
│   └── SentimentAnalysisPackage/
│       ├── Sources/
│       │   └── SentimentAnalysisPackage/
│       │       ├── SentimentResult.swift
│       │       └── SentimentAnalyzer.swift
│       └── Tests/
│           └── SentimentAnalysisPackageTests/
│               └── SentimentAnalysisPackageTests.swift
```

---

## Features

- Image classification using MobileNetV2
- Text sentiment analysis using NLTagger
- Asynchronous inference for both models
- Modular Swift Packages for each ML task
- Protocol-based abstraction for testability
- Benchmarking for model load and prediction latency
- Mock classifiers for CI and preview builds
- Clear error handling for invalid input and model state
- Unit test coverage ≥ 60%
- Graceful handling of unsupported image formats

---

## Example Usage

```swift
let classifier = MobileNetClassifier()
try classifier.loadModel()
classifier.predict(buffer: somePixelBuffer) { result in
    // handle label
}

let sentiment = await SentimentAnalyzer().analyzeAsync(text: "I love this app!")
print(sentiment.category) // .positive
print(sentiment.score)    // 0.87
```

---

## Testing

- XCTest coverage for both packages and app-level wrappers
- MockImageClassifier for fast, deterministic tests
- Benchmark logs for performance tracking
- Coverage ≥ 60% (run ⌘U in Xcode or use xcrun xccov)

---

## What I Learned

- How to modularize ML logic using Swift Packages
- How to run Core ML and NLTagger asynchronously
- How to structure an iOS app using MVVM and Clean Architecture
- How to benchmark and mock ML pipelines
- How to handle platform availability and input validation

---

## Bonus

- LinkedIn post summarizing the project
- Graceful fallback for unsupported image formats
- README-grade architecture and documentation
- CI-ready test suite with mock injection

---
