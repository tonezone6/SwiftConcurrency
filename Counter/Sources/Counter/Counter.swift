//
//  Timer.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

import Foundation
import SwiftConcurrencyExtensions

public struct Counter: AsyncSequence {
    public typealias Element = Int
    
    let limit: Int
    
    public init(limit: Int) {
        self.limit = limit
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(limit: limit)
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        let limit: Int
        var current = 0
        
        public mutating func next() async -> Int? {
            current += 1
            guard current <= limit else { return nil }
            await Task.sleep(seconds: 1)
            return current
        }
    }
}
