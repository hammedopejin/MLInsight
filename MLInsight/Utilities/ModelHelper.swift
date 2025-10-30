//
//  ModelHelper.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import Foundation
import CoreML
import UIKit
import MobileNetV2Package

protocol ImageClassifier {
    func loadModel() throws
    func predict(image: UIImage) throws -> String
}

final class MobileNetClassifier: ImageClassifier {
    private var model: MobileNetV2?

    func loadModel() throws {
        model = try MobileNetV2(configuration: MLModelConfiguration())
    }

    func predict(image: UIImage) throws -> String {
        guard let model = model else {
            throw ModelError.modelNotLoaded
        }

        guard let resized = image.resize(to: CGSize(width: 224, height: 224)),
              let buffer = resized.toCVPixelBuffer() else {
            throw ModelError.invalidImage
        }

        let output = try model.prediction(image: buffer)
        return output.classLabel
    }
}

enum ModelError: Error, LocalizedError {
    case modelNotLoaded
    case invalidImage

    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "The model has not been loaded yet."
        case .invalidImage:
            return "The image could not be processed."
        }
    }
}
