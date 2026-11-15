#!/usr/bin/env swift
// Generates App/Assets.xcassets/AppIcon.appiconset from the square source artwork in
// Design/AppIcon.png: a full-bleed, opaque 1024px icon for iOS (the system applies the rounded
// mask there) and rounded macOS icons with a drop shadow at every size.
// Usage: swift Scripts/make-icon.swift   (run from the repository root)
import AppKit
import Foundation

let fm = FileManager.default
let root = URL(fileURLWithPath: fm.currentDirectoryPath)
let sourceURL = root.appendingPathComponent("Design/AppIcon.png")
guard let source = NSImage(contentsOf: sourceURL)?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    fatalError("Cannot read \(sourceURL.path)")
}

let canvas: CGFloat = 1024
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!

func renderIcon(size: Int, fullBleed: Bool = false) -> Data {
    let px = CGFloat(size)
    let ctx = CGContext(
        data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB,
        bitmapInfo: fullBleed ? CGImageAlphaInfo.noneSkipLast.rawValue : CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.interpolationQuality = .high
    ctx.scaleBy(x: px / canvas, y: px / canvas)

    if fullBleed {
        // iOS / App Store: opaque, square corners, no alpha channel.
        ctx.draw(source, in: CGRect(x: 0, y: 0, width: canvas, height: canvas))
    } else {
        // macOS icon grid: 824pt rounded square centred on a 1024pt canvas, with a soft shadow.
        let tile = CGRect(x: 100, y: 100, width: 824, height: 824)
        let path = CGPath(roundedRect: tile, cornerWidth: 185, cornerHeight: 185, transform: nil)
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 28,
                      color: CGColor(colorSpace: sRGB, components: [0, 0, 0, 0.35])!)
        ctx.addPath(path)
        ctx.setFillColor(CGColor(colorSpace: sRGB, components: [0, 0.4, 0.27, 1])!)
        ctx.fillPath()
        ctx.restoreGState()
        ctx.addPath(path)
        ctx.clip()
        ctx.draw(source, in: tile)
    }

    let data = NSMutableData()
    let dest = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
    CGImageDestinationFinalize(dest)
    return data as Data
}

let iconset = root.appendingPathComponent("App/Assets.xcassets/AppIcon.appiconset")
try fm.createDirectory(at: iconset, withIntermediateDirectories: true)

var images: [[String: String]] = []

try renderIcon(size: 1024, fullBleed: true).write(to: iconset.appendingPathComponent("AppIcon-iOS.png"))
images.append(["filename": "AppIcon-iOS.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"])

for base in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let name = "AppIcon-mac-\(base)@\(scale)x.png"
        try renderIcon(size: base * scale).write(to: iconset.appendingPathComponent(name))
        images.append(["filename": name, "idiom": "mac", "scale": "\(scale)x", "size": "\(base)x\(base)"])
    }
}

let contents: [String: Any] = ["images": images, "info": ["author": "xcode", "version": 1]]
try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys])
    .write(to: iconset.appendingPathComponent("Contents.json"))
print("Wrote App/Assets.xcassets/AppIcon.appiconset")
