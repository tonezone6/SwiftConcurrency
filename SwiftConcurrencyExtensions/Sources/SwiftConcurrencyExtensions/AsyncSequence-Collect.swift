//
//  File.swift
//  
//
//  Created by Alex S. on 11/11/2022.
//

extension AsyncSequence {
    public func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}
