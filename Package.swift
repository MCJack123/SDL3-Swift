// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDL3",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SDL3",
            targets: ["SDL3"])
    ],
    dependencies: [
        .package(name: "SDL3_Native", path: "Packages/SDL3_Native")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SDL3", dependencies: ["SDL3_Native"]),
    ]
)
