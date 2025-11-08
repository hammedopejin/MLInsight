//
//  AudioLogWriterTests.swift
//  MLInsight
//
//  Created by blackmagic on 11/7/25.
//

import XCTest
@testable import AudioAnalysisPackage

final class AudioLogWriterTests: XCTestCase {

    func testSaveLogCreatesValidJSONFile() throws {
        let writer = AudioLogWriter()
        let predictions = [
            SoundPrediction(label: "Dog Bark", confidence: 0.92),
            SoundPrediction(label: "Car Horn", confidence: 0.75)
        ]
        let transcription = "This is a test transcription."

        try writer.saveLog(predictions: predictions, transcription: transcription)

        let url = try writer.logFileURL()
        let data = try Data(contentsOf: url)

        let decoded = try JSONDecoder().decode(AudioAnalysisLog.self, from: data)

        XCTAssertEqual(decoded.transcription, transcription)
        XCTAssertEqual(decoded.predictions.count, predictions.count)
        XCTAssertEqual(decoded.predictions[0].label, "Dog Bark")
        XCTAssertEqual(decoded.predictions[1].confidence, 0.75)
    }
}
