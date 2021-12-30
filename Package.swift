// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Baggins",
    products: [
        .library(
            name: "Baggins",
            targets: ["Baggins"]
        ),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Baggins",
            dependencies: []
        ),
        .testTarget(
            name: "BagginsTests",
            dependencies: ["Baggins"]
        ),
    ]
)
