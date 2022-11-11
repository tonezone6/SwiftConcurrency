// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DownloadClient",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "DownloadClient", targets: ["DownloadClient"]),
    ],
    dependencies: [
        .package(path: "SwiftConcurrencyExtensions")
    ],
    targets: [
        .target(
            name: "DownloadClient",
            dependencies: ["SwiftConcurrencyExtensions"]
        ),
        .testTarget(
            name: "DownloadClientTests",
            dependencies: ["DownloadClient"]),
    ]
)
