// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPowerStorage",
    platforms: [
          // Add support for all platforms starting from a specific version.
          .iOS(.v13)
      ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftPowerStorage",
            targets: ["SwiftPowerStorage"])
    ],
    dependencies: [
        .package(url: "https://github.com/CodeNationDev/SwiftMagicHelpers.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "SwiftPowerStorage",
            dependencies: ["SwiftMagicHelpers"]),
        .testTarget(
            name: "SwiftPowerStorageTests",
            dependencies: ["SwiftPowerStorage", "SwiftMagicHelpers"])
        
    ]
)
