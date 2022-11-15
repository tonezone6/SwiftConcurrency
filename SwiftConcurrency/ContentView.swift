//
//  ContentView.swift
//  SwiftConcurrency
//
//  Created by Alex S. on 15/11/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentModel()
    
    var body: some View {
        ZStack {
            Color(white: 0.95).ignoresSafeArea()
            VStack {
                if case .idle = model.status {
                    Text("Preparing...")
                }
                
                if case let .progress(value) = model.status {
                    VStack {
                        Text(value.progressPercent)
                            .fontWeight(.medium)
                        ProgressView(value: value)
                            .tint(.mint)
                    }
                }
                
                if case .finished = model.status {
                    HStack {
                        Text("Download finished")
                        Image.checkmarkCircle
                            .fontWeight(.semibold)
                            .foregroundColor(.mint)
                    }
                }
            }
            .frame(width: 200, height: 40)
            .cardStyle()
        }
        .task {
            await model.downloadLargeFile()
        }
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
