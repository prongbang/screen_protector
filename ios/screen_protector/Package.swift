// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "screen_protector",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "screen-protector", targets: ["screen_protector"])
    ],
    dependencies: [
        .package(url: "https://github.com/prongbang/ScreenProtectorKit.git", exact: "1.5.1"),
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "screen_protector",
            dependencies: [
                .product(name: "ScreenProtectorKit", package: "ScreenProtectorKit"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
