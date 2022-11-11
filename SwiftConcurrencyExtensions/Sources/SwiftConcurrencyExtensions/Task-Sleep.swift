//
//  Task-Sleep.swift
//  AsyncStream
//
//  Created by Alex S. on 30/10/2022.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async {
        do {
            let duration = UInt64(seconds * 1_000_000_000)
            try await sleep(nanoseconds: duration)
        } catch {
            print("sleep task failed", error.localizedDescription)
        }
    }
}
