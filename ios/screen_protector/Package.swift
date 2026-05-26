// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "screen_protector",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "screen-protector", targets: ["screen_protector"])
    ],
    dependencies: [
        .package(url: "https://github.com/prongbang/ScreenProtectorKit.git", exact: "1.5.1"),
    ],
    targets: [
        .target(
            name: "screen_protector",
            dependencies: [
                .product(name: "ScreenProtectorKit", package: "ScreenProtectorKit")
            ]
        )
    ]
)
