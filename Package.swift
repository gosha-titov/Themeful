// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Themeful",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Themeful",
            targets: ["Themeful"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Themeful",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ThemefulTests",
            dependencies: ["Themeful"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
