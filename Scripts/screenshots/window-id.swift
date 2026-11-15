// Prints the window number of the frontmost on-screen window of an app, for `screencapture -l`.
// Usage: swift Scripts/screenshots/window-id.swift <app name>
import CoreGraphics
import Foundation

let owner = CommandLine.arguments.dropFirst().first ?? "Feedlet"
let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
    as? [[String: Any]] ?? []
let match = windows.first { info in
    (info[kCGWindowOwnerName as String] as? String) == owner
        && (info[kCGWindowLayer as String] as? Int) == 0
        && ((info[kCGWindowBounds as String] as? [String: CGFloat])?["Height"] ?? 0) > 200
}
guard let number = match?[kCGWindowNumber as String] as? Int else {
    FileHandle.standardError.write(Data("No window of \(owner) found\n".utf8))
    exit(1)
}
print(number)
