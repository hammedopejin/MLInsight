//
//  ImageClassifierTests.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import XCTest
@testable import MobileNetV2Package
import UIKit
import CoreVideo

final class MobileNetClassifierTests: XCTestCase {
    func testModelLoadSuccess() {
        let classifier = MobileNetClassifier()
        XCTAssertNoThrow(try classifier.loadModel())
    }

    func testPredictionFailsWithoutModel() {
        let classifier = MobileNetClassifier()
        let buffer = pixelBuffer(from: UIImage(systemName: "photo")!)

        let expectation = XCTestExpectation(description: "Prediction should fail")

        classifier.predict(buffer: buffer!) { result in
            switch result {
            case .success:
                XCTFail("Prediction should fail when model is not loaded")
            case .failure(let error as ModelError):
                XCTAssertEqual(error, .modelNotLoaded)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testValidPrediction() {
        let classifier = MobileNetClassifier()
        try? classifier.loadModel()

        guard let buffer = pixelBuffer(from: UIImage(systemName: "photo")!) else {
            XCTFail("Failed to create pixel buffer")
            return
        }

        let expectation = XCTestExpectation(description: "Prediction should succeed")

        classifier.predict(buffer: buffer) { result in
            switch result {
            case .success(let label):
                XCTAssertFalse(label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            case .failure(let error):
                XCTFail("Prediction failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    // MARK: - Helper

    private func pixelBuffer(from image: UIImage, size: CGSize = CGSize(width: 224, height: 224)) -> CVPixelBuffer? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        let width = Int(size.width)
        let height = Int(size.height)

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ] as CFDictionary

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )

        guard let ctx = context else {
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
            return nil
        }

        ctx.draw(resizedImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

        return buffer
    }
}
