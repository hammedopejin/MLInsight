//
//  RootView.swift
//  MLInsight
//
//  Created by blackmagic on 10/29/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MobileNetView()
                .tabItem {
                    Label("Image", systemImage: "photo")
                }

            SentimentView()
                .tabItem {
                    Label("Sentiment", systemImage: "text.bubble")
                }

            AudioAnalyzerView()
                .tabItem {
                    Label("Audio", systemImage: "waveform")
                }
        }
    }
}
