// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-static-url",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "StaticUrl",
            targets: ["StaticUrl"]
        ),
    ],
    targets: [
        .target(
            name: "StaticUrl",
            path: "Sources"
        ),
        .testTarget(
            name: "StaticUrlTests",
            dependencies: ["StaticUrl"],
            path: "Tests"
        ),
    ]
)
