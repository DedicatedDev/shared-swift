// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "shared",
    platforms: [
        .iOS(.v12), .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Shared",
            targets: ["Shared"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore.git", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfDateTime.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "Shared",
            dependencies: [
                "WolfCore",
                "WolfDateTime"
            ]
        )
    ]
)
