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
            Text("Image Classifier")
                .font(.title2)
                .bold()

            if let image = viewModel.inputImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    )
                    .cornerRadius(12)
            }

            if let prediction = viewModel.prediction {
                Text("Prediction: \(prediction)")
                    .font(.headline)
                    .padding(.top, 8)
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
            .buttonStyle(.borderedProminent)

            Spacer()
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
