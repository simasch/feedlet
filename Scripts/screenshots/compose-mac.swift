// Places a window capture (with its shadow) centred on a 2880x1800 background in the app icon's green,
// the Mac App Store screenshot size.
// Usage: swift Scripts/screenshots/compose-mac.swift <window.png> <out.png>
import AppKit

let args = CommandLine.arguments
guard args.count == 3, let window = NSImage(contentsOfFile: args[1])?
    .cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    FileHandle.standardError.write(Data("Usage: compose-mac.swift <window.png> <out.png>\n".utf8))
    exit(1)
}

let size = CGSize(width: 2880, height: 1800)
let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8,
                    bytesPerRow: 0, space: space, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
func color(_ hex: UInt32) -> CGColor {
    CGColor(colorSpace: space, components: [CGFloat((hex >> 16) & 0xFF) / 255, CGFloat((hex >> 8) & 0xFF) / 255,
                                            CGFloat(hex & 0xFF) / 255, 1])!
}
let gradient = CGGradient(colorsSpace: space, colors: [color(0x0B5E45), color(0x08A57A)] as CFArray,
                          locations: [0, 1])!
ctx.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])

// Scale the window to fit with a margin, never up beyond its own pixels.
let margin: CGFloat = 120
let scale = min(1, (size.width - 2 * margin) / CGFloat(window.width), (size.height - 2 * margin) / CGFloat(window.height))
let drawn = CGSize(width: CGFloat(window.width) * scale, height: CGFloat(window.height) * scale)
ctx.interpolationQuality = .high
ctx.draw(window, in: CGRect(x: (size.width - drawn.width) / 2, y: (size.height - drawn.height) / 2,
                            width: drawn.width, height: drawn.height))

let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
try rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: args[2]))
