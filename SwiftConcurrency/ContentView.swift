//
//  ContentView.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentModel()
    
    var body: some View {
        ZStack {
            Color(white: 0.95).ignoresSafeArea()
            VStack {
                if case .idle = model.status {
                    Button("Start", action: startDownload)
                        .mintButtonStyle()
                }
                
                if case let .progress(value) = model.status {
                    VStack {
                        Text(model.status.progressPercent)
                            .fontWeight(.medium)
                        ProgressView(value: value)
                            .tint(.mint)
                    }
                    .frame(width: 200, height: 40)
                    .cardStyle()
                    
                    Button("Stop", action: stopDownload)
                        .mintButtonStyle()
                }
                
                if case .finished = model.status {
                    HStack {
                        Text("Download finished")
                        Image.checkmarkCircle
                            .fontWeight(.semibold)
                            .foregroundColor(.mint)
                    }
                    .frame(width: 200, height: 40)
                    .cardStyle()
                }
            }
        }
    }
    
    func startDownload() {
        Task {
            await model.downloadLargeFile()
        }
    }
    
    func stopDownload() {
        model.cancelDownload()
    }
}

extension View {
    func cardStyle(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 8,
        strokeColor: Color = .gray.opacity(0.2),
        lineWidth: CGFloat = 2
    ) -> some View {
        self.padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
    
    func mintButtonStyle() -> some View {
        self.buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
            .tint(.mint)
    }
}

extension Image {
    static let checkmarkCircle = Image(systemName: "checkmark.circle")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init(client: .mock))
    }
}
