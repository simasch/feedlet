#if DEBUG
import Foundation

/// App Store screenshots only (Debug builds): `-screenshot <scene>` opens a fixed screen and skips the feed refresh,
/// so the sample library from `Scripts/screenshots.sh` is shown as it is. Compiled out of Release builds.
enum ScreenshotMode {
    enum Scene: String {
        case sidebar, list, article, starred, addFeed
    }

    static let scene: Scene? = UserDefaults.standard.string(forKey: "screenshot").flatMap(Scene.init(rawValue:))

    static var isActive: Bool { scene != nil }
}
#endif
