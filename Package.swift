// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mParticle-Singular",
    platforms: [ .iOS(.v12) ],
    products: [
        .library(
            name: "mParticle-Singular",
            targets: ["mParticle-Singular"]),
    ],
    dependencies: [
      .package(url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.19.0")),
      .package(url: "https://github.com/singular-labs/Singular-iOS-SDK",
               .upToNextMajor(from: "12.4.1")),
    ],
    targets: [
        .target(
            name: "mParticle-Singular",
            dependencies: [
               .product(name: "mParticle-Apple-SDK", package: "mparticle-apple-sdk"),
               .product(name: "Singular", package: "Singular-iOS-SDK"),
            ]
        )
    ]
)
