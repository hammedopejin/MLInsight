//
//  MobileNetView.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import SwiftUI
import PhotosUI

struct MobileNetView: View {
    @StateObject private var viewModel = MobileNetViewModel()
    @State private var showImagePicker = false
    @State private var showErrorAlert = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.inputImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No Image Selected").foregroundColor(.gray))
            }

            if let prediction = viewModel.prediction {
                Text("Prediction: \(prediction)")
                    .font(.headline)
            }

            HStack(spacing: 20) {
                Button("Select Image") {
                    showImagePicker = true
                }

                Button("Run Inference") {
                    viewModel.runInference()
                }
                .disabled(viewModel.inputImage == nil)
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $viewModel.inputImage)
        }
        .onAppear {
            viewModel.loadModel()
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            showErrorAlert = newValue != nil
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                }
            )
        }
    }
}
