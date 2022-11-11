//
//  ConnectionClient.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

struct ConnectionClient {
    let connected: () -> AsyncStream<Bool>
}
