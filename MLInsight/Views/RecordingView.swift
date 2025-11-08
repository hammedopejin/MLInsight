//
//  RecordingView.swift
//  MLInsight
//
//  Created by blackmagic on 11/7/25.
//

import SwiftUI

struct RecordingView: View {
    @ObservedObject var viewModel: AudioAnalyzerViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.isRecording ? "Recording..." : "Tap to Record")
                .font(.headline)

            Text(viewModel.formattedDuration())
                .font(.system(.title, design: .monospaced))
                .foregroundColor(.red)

            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    try? viewModel.startRecording()
                }
            }) {
                Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
