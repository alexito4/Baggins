// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Baggins",
    platforms: [.iOS(.v14), .macOS(.v10_15)],
    products: [
        .library(
            name: "Baggins",
            targets: ["Baggins"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/alexito4/Flow.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/alexito4/UnwrapOrThrow", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "Baggins",
            dependencies: [
                "Flow",
                "UnwrapOrThrow",
            ]
        ),
        .testTarget(
            name: "BagginsTests",
            dependencies: ["Baggins"]
        ),
    ]
)
