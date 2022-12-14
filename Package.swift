// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FTKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "FTKit", targets: ["FTKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "FTKit", dependencies: [])
    ]
)
