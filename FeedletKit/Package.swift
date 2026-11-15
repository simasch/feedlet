// swift-tools-version: 6.0
import PackageDescription

/// Platform-independent core of Feedlet: models, feed parsing and fetching, persistence, OPML.
/// The app UI lives in ../App and is built by ../Feedlet.xcodeproj.
let package = Package(
    name: "FeedletKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "FeedletKit", targets: ["FeedletKit"]),
    ],
    targets: [
        .target(name: "FeedletKit"),
        .testTarget(name: "FeedletKitTests", dependencies: ["FeedletKit"]),
    ]
)
