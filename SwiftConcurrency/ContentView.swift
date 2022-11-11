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
                    Text("Preparing...")
                }
                
                if case let .progress(value) = model.status {
                    VStack {
                        Text(model.status.percent)
                            .fontWeight(.medium)
                        ProgressView(value: value)
                            .tint(.mint)
                    }
                }
                
                if case .finished = model.status {
                    HStack {
                        Text("Download finished")
                        Image(systemName: "checkmark.circle")
                            .fontWeight(.semibold)
                            .foregroundColor(.mint)
                    }
                }
            }
            .frame(width: 200, height: 40)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
        }
        .task {
            await model.downloadLargeFile()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init(client: .mock))
    }
}
