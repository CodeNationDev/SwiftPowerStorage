// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreLogger",
    platforms: [
          // Add support for all platforms starting from a specific version.
          .iOS(.v11),
          .tvOS(.v11),
          .watchOS(.v4),
          .macOS(.v10_12),
      ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CoreLogger",
            targets: ["CoreLogger"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CoreLogger",
            dependencies: [])
    ]
)
