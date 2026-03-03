// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SmartShopperAI",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0")
    ],
    targets: [
        .target(
            name: "SmartShopperAI",
            dependencies: ["SwiftSoup"]
        )
    ]
)
