// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CRNetworking",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CRNetworking",
            targets: ["CRNetworking"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CRNetworking",
            dependencies: [],
            path: "Sources/CRNetworking"),
        .testTarget(
            name: "CRNetworkingTests",
            dependencies: ["CRNetworking"])
    ]
)
