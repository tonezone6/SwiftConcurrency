//
//  ContentModel.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

import Counter
import Foundation
import SwiftConcurrencyExtensions

class ContentModel: ObservableObject {
    
    @Published var status: DownloadStatus?
    @Published var error: Error?
    
    init() {}
    
    @MainActor
    func downloadLargeFile() async {
        let start = Date.now
        var count = 0
        
        do {
            let string = "http://ipv4.download.thinkbroadband.com/10MB.zip"
            let url = URL(string: string)!
            let (bytes, response) = try await URLSession.shared.bytes(from: url)
            let lenght = response.expectedContentLength
            
            let chunks = bytes.chunked(size: 320_768) // 32KB
            let sequence = chunks.convertToDownloadStatus(expectedLenght: lenght)
            
            for try await status in sequence {
                self.status = status
                count += 1
            }
        } catch {
            self.error = error
        }
        
        print("Chunks,", count)
        print("Duration, \(Date.now.timeIntervalSince(start))")
    }
}

extension DownloadStatus {
    var progressPercent: String {
        if case let .progress(value) = self {
            return String(format: "%.0f", value * 100) + "%"
        }
        return ""
    }
}
