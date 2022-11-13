//
//  ContentModel.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

import Counter
import DownloadClient
import Foundation

class ContentModel: ObservableObject {
    let client: DownloadClient
    var task: Task<Void, Never>?
    
    @Published var status: DownloadClient.Status = .idle
    @Published var error: Error?
    
    init(client: DownloadClient = .live) {
        self.client = client
    }
    
    @MainActor
    func downloadLargeFile() async {
        let string = "http://ipv4.download.thinkbroadband.com/1MB.zip"
        let url = URL(string: string)!
        let sequence = client.download(url)
        
        task = Task {
            do {
                for try await status in sequence {
                    self.status = status
                }
            } catch {
                self.error = error
            }
        }
    }
    
    func cancelDownload() {
        task?.cancel()
        status = .idle
    }
}

extension DownloadClient.Status {
    var progressPercent: String {
        if case let .progress(value) = self {
            return String(format: "%.0f", value * 100) + "%"
        }
        return ""
    }
}
