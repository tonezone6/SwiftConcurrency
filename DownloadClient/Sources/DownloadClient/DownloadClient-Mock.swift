//
//  File.swift
//  
//
//  Created by Alex S. on 09/11/2022.
//

import Foundation
import SwiftConcurrencyExtensions

extension DownloadClient {
    public static let mock = DownloadClient(download: { url in
        AsyncThrowingStream { continuation in
            Task {
                await Task.sleep(seconds: 1)
                continuation.yield(.progress(0))
                
                await Task.sleep(seconds: 1)
                continuation.yield(.progress(0.25))
                
                await Task.sleep(seconds: 1)
                continuation.yield(.progress(0.5))
                
                await Task.sleep(seconds: 1)
                continuation.yield(.progress(0.75))
                
                await Task.sleep(seconds: 1)
                continuation.yield(.finished(Data()))
                
                continuation.finish()
            }
        }
    })
}
