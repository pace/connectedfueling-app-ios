// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Domain", dependencies: []),
        .testTarget(name: "DomainTests", dependencies: ["Domain"]),
    ]
)
