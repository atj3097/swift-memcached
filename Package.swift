// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MemcachedClient",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "MemcachedClient",
            targets: ["MemcachedClient"]),
        .executable(
            name: "MemcachedClientApp",
            targets: ["MemcachedClientApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MemcachedClient",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Logging", package: "swift-log")
            ]),
        .target(
            name: "MemcachedClientApp",
            dependencies: ["MemcachedClient"]),
        .testTarget(
            name: "MemcachedClientTests",
            dependencies: ["MemcachedClient"]),
    ]
)
