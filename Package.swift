// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FTKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "FTKit",
            targets: ["FTKit", 
                      "MediaPipeTasksCommon", "MediaPipeTasksVision"
                     ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(name: "FTKit", dependencies: []),
        .binaryTarget(name: "MediaPipeTasksCommon", path: "./Sources/MPP/MediaPipeTasksCommon.xcframework"),
        .binaryTarget(name: "MediaPipeTasksVision", path: "./Sources/MPP/MediaPipeTasksVision.xcframework")
    ]
)
