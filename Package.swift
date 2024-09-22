// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "strings",
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "strings",
      targets: ["strings"]),
    .executable(
      name: "strings-benchmark",
      targets: ["strings-benchmark"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/google/swift-benchmark", from: "0.1.2"),
    .package(url: "https://github.com/apple/swift-numerics", from: "1.0.2")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "strings",
      dependencies: []),
    .executableTarget(
      name: "strings-benchmark",
      dependencies: ["strings", .product(name: "Benchmark", package: "swift-benchmark")]),
    .testTarget(
      name: "stringsTests",
      dependencies: ["strings", .product(name: "Numerics", package: "swift-numerics")])
  ]
)
