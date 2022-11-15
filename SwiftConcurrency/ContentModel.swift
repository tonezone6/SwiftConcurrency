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
    @Published var status: DownloadStatus = .idle
        
    @MainActor
    func downloadLargeFile() async {
        let start = Date.now
        var count = 0
        
        do {
            let string = "http://ipv4.download.thinkbroadband.com/10MB.zip"
            let url = URL(string: string)!
            let (bytes, response) = try await URLSession.shared.bytes(from: url)
            let lenght = response.expectedContentLength
            let chunks = bytes.chunks(size: 327_680) // 320KB
            let sequence = chunks.downloadStatus(expectedLenght: lenght)
            
            for try await status in sequence {
                self.status = status
                print(status)
                count += 1
            }
        } catch {
            print(error.localizedDescription)
        }
        
        print("Chunks,", count)
        print("Duration, \(Date.now.timeIntervalSince(start))")
    }
}

extension Double {
    var progressPercent: String {
        String(format: "%.0f", self * 100) + "%"
    }
}
