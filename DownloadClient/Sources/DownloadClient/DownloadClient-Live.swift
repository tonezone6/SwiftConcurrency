//
//  File.swift
//  
//
//  Created by Alex S. on 09/11/2022.
//

import Foundation

extension DownloadClient {
    public static let live = DownloadClient(download: { url in
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(from: url)
                    let expectedLenght = Double(response.expectedContentLength)
                    var data = Data()
                    
                    for try await byte in bytes {
                        data.append(byte)
                        
                        let lenght = Double(data.count)
                        if lenght < expectedLenght {
                            let value = lenght/expectedLenght
                            // TODO: throttle values
                            continuation.yield(.progress(value))
                        }
                    }
                    
                    continuation.yield(.finished(data))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    })
}
