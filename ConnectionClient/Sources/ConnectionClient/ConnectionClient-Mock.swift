//
//  File.swift
//  
//
//  Created by Alex S. on 09/11/2022.
//

import Foundation
import SwiftConcurrencyExtensions

extension ConnectionClient {
    public static let mock = ConnectionClient(connected: {
        AsyncStream { continuation in
            Task {
                await Task.sleep(seconds: 2)
                continuation.yield(false)
                
                await Task.sleep(seconds: 2)
                continuation.yield(true)
            }
        }
    })
}
