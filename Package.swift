// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "fluent-postgis",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "PostGIS",
            targets: ["PostGIS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
    ],
    targets: [
        .target(
            name: "PostGIS",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
            ]
        ),
        .testTarget(
            name: "PostGISTests",
            dependencies: ["PostGIS"]),
    ]
)
