// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "screen_protector",
    platforms: [
        .iOS("11.0")
    ],
    products: [
        .library(name: "screen-protector", targets: ["screen_protector"])
    ],
    dependencies: [
        .package(url: "https://github.com/prongbang/ScreenProtectorKit.git", from: "1.4.5")
    ],
    targets: [
        .target(
            name: "screen_protector",
            dependencies: [
                "ScreenProtectorKit",
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            swiftSettings: [
                .define("USE_SPM")
            ]
        )
    ]
)
