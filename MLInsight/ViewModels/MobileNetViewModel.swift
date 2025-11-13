//
//  MobileNetViewModel.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import SwiftUI
import MobileNetV2Package

@MainActor
final class MobileNetViewModel: ObservableObject {
    @Published var inputImage: UIImage?
    @Published var prediction: String?
    @Published var errorMessage: String?

    private let classifier: ImageClassifier = MobileNetClassifier()

    func loadModel() {
        do {
            try classifier.loadModel()
        } catch {
            handleError("Model load failed", error)
        }
    }

    func selectImage() {
        print("Image selection not implemented yet.")
    }

    func runInference() {
        guard let image = inputImage else {
            errorMessage = "No image selected"
            logError(errorMessage)
            return
        }

        Task {
            do {
                let result = try await classifier.predict(image: image)
                prediction = result
            } catch {
                handleError("Inference failed", error)
            }
        }
    }

    private func handleError(_ context: String, _ error: Error) {
        let message = "\(context): \(error.localizedDescription)"
        errorMessage = message
        logError(message)
    }

    private func logError(_ message: String?) {
        guard let msg = message else { return }
        print("[MLInsight Error] \(msg)")
    }
}
