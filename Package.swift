// swift-tools-version: 6.0
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-static-url",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StaticUrl",
            targets: ["StaticUrl"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "StaticUrlMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/StaticUrlMacro"
        ),
        .target(
            name: "StaticUrl",
            dependencies: ["StaticUrlMacro"],
            path: "Sources/StaticUrl"
        ),
        .testTarget(
            name: "StaticUrlTests",
            dependencies: [
                "StaticUrlMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            path: "Tests"
        ),
    ]
)
