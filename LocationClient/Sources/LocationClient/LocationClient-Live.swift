//
//  File.swift
//  
//
//  Created by Alex S. on 09/11/2022.
//

import MapKit

extension LocationClient {
    
    public static let live = LocationClient(requestLocation: {
        try await withCheckedThrowingContinuation { continuation in
            let delegate = Delegate(continuation: continuation)
            delegate.requestLocation()
        }
    })
    
    private class Delegate: NSObject, CLLocationManagerDelegate {
        typealias Continuation = CheckedContinuation<CLLocationCoordinate2D?, Error>
        
        let manager = CLLocationManager()
        let continuation: Continuation

        init(continuation: Continuation) {
            self.continuation = continuation
            super.init()
            
            manager.delegate = self
        }
        
        func requestLocation() {
            manager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            continuation.resume(returning: locations.first?.coordinate)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            continuation.resume(throwing: error)
        }
    }
}

// MARK: protocol version

//protocol LocationClientProtocol {
//    func requestLocation() async throws -> CLLocationCoordinate2D?
//}
//
//final class LocationClientLive: NSObject, LocationClientProtocol {
//
//    private let manager = CLLocationManager()
//    private var continuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() async throws -> CLLocationCoordinate2D? {
//        try await withCheckedThrowingContinuation { continuation in
//            self.continuation = continuation
//            manager.requestLocation()
//        }
//    }
//}
//
//extension LocationClientLive: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        continuation?.resume(returning: locations.first?.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        continuation?.resume(throwing: error)
//    }
//}
