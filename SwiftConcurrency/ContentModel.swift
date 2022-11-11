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
    
    @Published var status: DownloadClient.Status = .idle
    @Published var error: Error?
    
    init(client: DownloadClient = .mock) {
        self.client = client
    }
    
    @MainActor
    func downloadLargeFile() async {
        let string = "http://ipv4.download.thinkbroadband.com/1MB.zip"
        let url = URL(string: string)!
        
        do {
            for try await status in client.download(url) {
                self.status = status
            }
        } catch {
            self.error = error
        }
    }
    
    func collectCounts() async {
        let stream = Counter(limit: 6)
        let values = await stream.collect()
        print(values)
    }
}
