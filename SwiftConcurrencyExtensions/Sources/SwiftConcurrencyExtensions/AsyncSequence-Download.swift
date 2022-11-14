//
//  File.swift
//  
//
//  Created by Alex S. on 14/11/2022.
//

import Foundation

extension AsyncSequence where Element == Data {
    public func convertToDownloadStatus(expectedLenght: Int64) -> DownloadStatusSequence<Self> {
        DownloadStatusSequence(self, lenght: expectedLenght)
    }
}

public enum DownloadStatus {
    case progress(Double)
    case finished(Data)
}

public struct DownloadStatusSequence<Base: AsyncSequence>: AsyncSequence where Base.Element == Data {
    public typealias Element = DownloadStatus
    
    let base: Base
    let lenght: Int64
            
    public init(_ base: Base, lenght: Int64) {
        self.base = base
        self.lenght = lenght
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(base: base.makeAsyncIterator(), lenght: lenght)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        var base: Base.AsyncIterator
        let lenght: Int64
        
        var data = Data()
        
        public mutating func next() async throws -> DownloadStatus? {
            guard Task.isCancelled == false else {
                return nil
            }
            
            guard let element = try await base.next() else {
                return nil
            }
            
            data.append(element)
            
            if data.count < lenght {
                return .progress(Double(data.count)/Double(lenght))
            } else {
                return .finished(data)
            }
        }
    }
}

