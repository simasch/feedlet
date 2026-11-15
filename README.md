# Feedlet

A small native RSS/Atom reader for macOS, iPhone and iPad, written in Swift and SwiftUI. No third-party dependencies.

## Features

- Three-pane layout: smart feeds (Unread, All, Starred) and subscriptions, article list, article view
  (on iPhone the same columns become a drill-down)
- Add a feed by its URL **or** by a website URL (the feed is discovered from `<link rel="alternate">`)
- Parses RSS 2.0, RSS 1.0 (RDF) and Atom, including `content:encoded` and Atom XHTML content
- Read/unread and starred state, unread badges, mark all as read
- Refreshes on launch and every 30 minutes, using conditional GET (`ETag` / `Last-Modified`)
- OPML import/export (File menu on macOS, ⋯ menu in the sidebar on iOS); folders are flattened on import
- Articles render with JavaScript disabled; links open in your default browser
- iOS: pull to refresh, swipe right to toggle read, swipe left to star, long-press for more, share sheet
- Library stored as JSON in the app's sandbox container, under
  `Library/Application Support/Feedlet/library.json`
  (on macOS: `~/Library/Containers/ch.martinelli.feedlet/Data/Library/Application Support/Feedlet/`)

## Build and run

Requires Xcode (Swift 6). The app runs on macOS 14+ and iOS/iPadOS 17+.

Open `Feedlet.xcodeproj`, pick *My Mac*, a simulator or a device as the destination, and press ⌘R.
⌘U runs the tests. One multiplatform target builds both the Mac and the iOS app.

From the terminal:

```sh
Scripts/build-app.sh                       # build "build/Feedlet.app" (macOS, Release)
DEVELOPMENT_TEAM=<team id> Scripts/release.sh [--upload]   # App Store archives, see docs/app-store-release.md
open "build/Feedlet.app"

xcodebuild -project Feedlet.xcodeproj -scheme Feedlet \
  -destination 'generic/platform=iOS Simulator' build    # iOS build

cd FeedletKit && swift test              # core tests, no Xcode project needed
```

To run on a physical iPhone or to distribute, choose your team under *Signing & Capabilities* and
change the bundle identifier (`ch.martinelli.feedlet`) to one you own if you build your own copy. Without a team, the Mac app is
signed to run locally.

The Mac app is sandboxed (outgoing network connections and user-selected files only).

The app icons in `App/Assets.xcassets` (rounded macOS sizes and a full-bleed iOS icon) are generated
from the square artwork in `Design/AppIcon.png`; run `swift Scripts/make-icon.swift` after replacing it.

## Keyboard shortcuts

| Shortcut | Action |
|---|---|
| ↑ / ↓ | Previous / next article (when the article list has focus) |
| ⌘N | Add feed |
| ⌘R | Refresh all |
| ⌘K | Mark all in current list as read |
| ⇧⌘U | Toggle read |
| ⇧⌘L | Toggle star |
| ⌘B | Open article in browser |

## Layout

```
Feedlet.xcodeproj        Multiplatform app target (macOS, iOS, iPadOS), shared scheme
App/                       App target sources: SwiftUI, with #if os(...) for platform differences
  FeedletApp.swift       App entry, macOS menu commands, auto-refresh, iOS save-on-background
  Platform.swift           Pasteboard and OPML type helpers
  Views/                   Sidebar, article list, article view, add-feed sheet
  Assets.xcassets          App icons
  Info.plist               App Transport Security exception for plain-HTTP feeds
FeedletKit/              Local Swift package with the platform-independent core
  Sources/FeedletKit/
    Models.swift           Feed, Article, SidebarItem, FeedError
    FeedParser.swift       XMLParser-based RSS/Atom parser, date parsing
    FeedFetcher.swift      HTTP fetching, conditional GET, feed discovery
    FeedStore.swift        Observable state, merging, persistence
    OPML.swift             OPML import/export
    HTMLText.swift         Tag stripping and escaping helpers
  Tests/FeedletKitTests/
Scripts/
  build-app.sh             Release build of the Mac app
  make-icon.swift          Generates the app icons from Design/AppIcon.png
  release.sh               App Store archives and upload (iOS + macOS)
  ExportOptions.plist      Export settings for release.sh
```

## Ideas for next steps

Folders, search, JSON Feed support, full-text extraction for excerpt-only feeds,
iCloud or Feedbin/Feedly sync, notifications for new articles.
