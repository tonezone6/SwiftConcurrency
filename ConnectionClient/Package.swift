// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConnectionClient",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ConnectionClient", targets: ["ConnectionClient"])
    ],
    dependencies: [
        .package(path: "SwiftConcurrencyExtensions")
    ],
    targets: [
        .target(
            name: "ConnectionClient",
            dependencies: ["SwiftConcurrencyExtensions"]
        ),
        .testTarget(
            name: "ConnectionClientTests",
            dependencies: ["ConnectionClient"]),
    ]
)
