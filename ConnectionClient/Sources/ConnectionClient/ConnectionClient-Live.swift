//
//  File.swift
//  
//
//  Created by Alex S. on 09/11/2022.
//

import Network

extension ConnectionClient {
    
    public static let live = ConnectionClient(connected: {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()
            
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            
            continuation.onTermination = { @Sendable _ in
                monitor.cancel()
            }
            
            let queue = DispatchQueue(label: "connection_monitor")
            monitor.start(queue: queue)
        }
    })
}
