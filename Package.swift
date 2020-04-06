// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevHelper",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "DevHelper", targets: ["DevHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/krimpedance/KRProgressHUD.git", from: "3.4.5"),
    ],
    targets: [
        .target(name: "DevHelper", dependencies: ["SnapKit", "KRProgressHUD"], path: "Sources/DevHelper"),
    ]
)
