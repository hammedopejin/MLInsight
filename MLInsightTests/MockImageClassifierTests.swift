//
//  MockImageClassifierTests.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import XCTest
@testable import MobileNetV2Package
import CoreVideo

final class MockImageClassifierTests: XCTestCase {
    func testMockSuccess() {
        let mock = MockImageClassifier(mode: .alwaysSuccess(label: "MockLabel"))
        let buffer = dummyPixelBuffer()

        let expectation = XCTestExpectation(description: "Mock prediction should succeed")

        mock.predict(buffer: buffer) { result in
            switch result {
            case .success(let label):
                XCTAssertEqual(label, "MockLabel")
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testMockFailure() {
        let mock = MockImageClassifier(mode: .alwaysFail(error: ModelError.modelNotLoaded))
        let buffer = dummyPixelBuffer()

        let expectation = XCTestExpectation(description: "Mock prediction should fail")

        mock.predict(buffer: buffer) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error as ModelError):
                XCTAssertEqual(error, .modelNotLoaded)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    private func dummyPixelBuffer() -> CVPixelBuffer {
        var buffer: CVPixelBuffer?
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            224,
            224,
            kCVPixelFormatType_32ARGB,
            nil,
            &buffer
        )
        return buffer!
    }
}
