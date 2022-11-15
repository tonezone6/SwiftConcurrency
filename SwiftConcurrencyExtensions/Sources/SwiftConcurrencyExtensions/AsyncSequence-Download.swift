//
//  File.swift
//  
//
//  Created by Alex S. on 14/11/2022.
//

import Foundation

extension AsyncSequence where Element == Data {
    public func downloadStatus(expectedLenght: Int64) -> DownloadStatusSequence<Self> {
        DownloadStatusSequence(self, expectedLenght: expectedLenght)
    }
}

public enum DownloadStatus {
    case idle
    case progress(Double)
    case finished(Data)
}

public struct DownloadStatusSequence<Base: AsyncSequence>: AsyncSequence where Base.Element == Data {
    public typealias Element = DownloadStatus
    
    let base: Base
    let expectedLenght: Int64
            
    public init(_ base: Base, expectedLenght: Int64) {
        self.base = base
        self.expectedLenght = expectedLenght
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(
            base: base.makeAsyncIterator(),
            expectedLenght: expectedLenght
        )
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        var base: Base.AsyncIterator
        let expectedLenght: Int64
        var data = Data()
        
        public mutating func next() async throws -> DownloadStatus? {
            guard Task.isCancelled == false else {
                return nil
            }
            
            guard let element = try await base.next() else {
                return nil
            }

            data.append(element)

            if data.count < expectedLenght {
                return .progress(Double(data.count)/Double(expectedLenght))
            } else {
                return .finished(data)
            }
        }
    }
}

