// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MimeerApp",
    platforms: [
       .macOS(.v14),
       .iOS(.v17),
    ],
    products: [
        .library(
            name: "MimeerApp",
            targets: ["MimeerApp"]
        ),
        .library(
            name: "MimeerKit",
            targets: ["MimeerKit"]
        ),
        .library(
            name: "MimeerWidgets",
            targets: ["MimeerWidgets"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/StarLard/StarLardKit.git", branch: "master"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", .upToNextMajor(from: "8.46.0")),
        .package(url: "https://github.com/StarLard/SwiftFormatPlugins.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "MimeerApp",
            dependencies: [
                "MimeerKit",
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatPlugins")
            ]
        ),
        .testTarget(
            name: "MimeerAppTests",
            dependencies: ["MimeerApp"],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatPlugins")
            ]
        ),
        .target(
            name: "MimeerKit",
            dependencies: ["StarLardKit"],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatPlugins")
            ]
        ),
        .testTarget(
            name: "MimeerKitTests",
            dependencies: ["MimeerKit"],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatPlugins")
            ]
        ),
        .target(
            name: "MimeerWidgets",
            dependencies: ["MimeerKit"],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatPlugins")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
