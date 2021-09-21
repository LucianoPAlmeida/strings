// swift-tools-version:5.3
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
    .package(name: "Benchmark", url: "https://github.com/google/swift-benchmark", from: "0.1.1"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "strings",
      dependencies: []),
    .target(
      name: "strings-benchmark",
      dependencies: ["strings", "Benchmark"]),
    .testTarget(
      name: "stringsTests",
      dependencies: ["strings"]),
  ]
)
