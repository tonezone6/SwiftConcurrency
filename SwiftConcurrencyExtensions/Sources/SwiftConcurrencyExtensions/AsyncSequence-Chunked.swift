//
//  File.swift
//  
//
//  Created by Alex S. on 14/11/2022.
//

import Foundation

extension AsyncSequence where Element == UInt8 {
    public func chunks(size: Int) -> Chunks<Self> {
        Chunks(self, size: size)
    }
}

public struct Chunks<Base: AsyncSequence>: AsyncSequence where Base.Element == UInt8 {
    public typealias Element = Data
    
    let base: Base
    let size: Int
    
    init(_ base: Base, size: Int) {
        self.base = base
        self.size = size
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator(), size: size)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        var base: Base.AsyncIterator
        let size: Int
        
        public mutating func next() async throws -> Data? {
            var chunk = Data()
            while let byte = try await base.next() {
                chunk.append(byte)
                if chunk.count == size {
                    return chunk
                }
            }
            return chunk.isEmpty ? nil : chunk
        }
    }
}

