import AppKit
import Foundation

struct CopyManifest: Decodable {
    let entries: [Entry]

    struct Entry: Decodable {
        let order: Int
        let scene: String
        let language: String
        let headline: String
        let subheadline: String
        let cropTopRatio: Double
        let cropHeightRatio: Double
    }
}

let arguments = CommandLine.arguments
guard arguments.count == 5 else {
    fputs("Usage: compose-store-screenshots.swift <config> <raw-root> <output-root> <icon>\n", stderr)
    exit(1)
}

let configURL = URL(fileURLWithPath: arguments[1])
let rawRootURL = URL(fileURLWithPath: arguments[2], isDirectory: true)
let outputRootURL = URL(fileURLWithPath: arguments[3], isDirectory: true)
let iconURL = URL(fileURLWithPath: arguments[4])

let data = try Data(contentsOf: configURL)
let manifest = try JSONDecoder().decode(CopyManifest.self, from: data)
let fileManager = FileManager.default
let iconImage = NSImage(contentsOf: iconURL)

func nsColor(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
    NSColor(
        red: CGFloat((hex >> 16) & 0xFF) / 255,
        green: CGFloat((hex >> 8) & 0xFF) / 255,
        blue: CGFloat(hex & 0xFF) / 255,
        alpha: alpha
    )
}

let sand = nsColor(0xF4EFE6)
let sandStrong = nsColor(0xFBF7EF)
let evergreen = nsColor(0x2F725B)
let evergreenDeep = nsColor(0x21463B)
let muted = nsColor(0x607468)
let amber = nsColor(0xE39442)

func drawBackground(in rect: CGRect) {
    sand.setFill()
    rect.fill()

    let gradient = NSGradient(colors: [
        nsColor(0xFBF7EF),
        nsColor(0xF1ECE1)
    ])!
    gradient.draw(in: rect, angle: -90)

    nsColor(0xE39442, alpha: 0.12).setFill()
    NSBezierPath(ovalIn: CGRect(x: rect.width * 0.68, y: rect.height * 0.74, width: rect.width * 0.34, height: rect.width * 0.34)).fill()

    nsColor(0x2F725B, alpha: 0.10).setFill()
    NSBezierPath(ovalIn: CGRect(x: -rect.width * 0.12, y: rect.height * 0.70, width: rect.width * 0.46, height: rect.width * 0.46)).fill()
}

func attributed(_ string: String, font: NSFont, color: NSColor) -> NSAttributedString {
    NSAttributedString(
        string: string,
        attributes: [
            .font: font,
            .foregroundColor: color,
            .kern: -0.5
        ]
    )
}

func topCrop(of cgImage: CGImage, topRatio: Double, heightRatio: Double) -> CGImage? {
    let width = cgImage.width
    let height = cgImage.height
    let cropHeight = max(1, Int(CGFloat(height) * CGFloat(heightRatio)))
    let topOffset = Int(CGFloat(height) * CGFloat(topRatio))
    let y = max(0, min(height - cropHeight, topOffset))
    return cgImage.cropping(to: CGRect(x: 0, y: y, width: width, height: cropHeight))
}

for deviceClass in ["6.1-inch", "6.7-inch"] {
    for entry in manifest.entries {
        let inputURL = rawRootURL
            .appendingPathComponent(deviceClass)
            .appendingPathComponent(entry.language)
            .appendingPathComponent("\(entry.scene).png")

        guard let rawImage = NSImage(contentsOf: inputURL),
              let rawCG = rawImage.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let croppedCG = topCrop(of: rawCG, topRatio: entry.cropTopRatio, heightRatio: entry.cropHeightRatio) else {
            fputs("Missing or unreadable raw screenshot: \(inputURL.path)\n", stderr)
            exit(1)
        }

        let canvasSize = NSSize(width: rawCG.width, height: rawCG.height)
        let outputImage = NSImage(size: canvasSize)
        outputImage.lockFocus()

        let ctx = NSGraphicsContext.current!.cgContext
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)

        let canvasRect = CGRect(origin: .zero, size: canvasSize)
        drawBackground(in: canvasRect)

        if let iconImage {
            let iconRect = CGRect(x: 78, y: canvasRect.height - 174, width: 76, height: 76)
            iconImage.draw(in: iconRect)
        }

        let eyebrow = attributed(
            "ExpiryPal",
            font: .systemFont(ofSize: canvasRect.width * 0.026, weight: .semibold),
            color: amber
        )
        eyebrow.draw(at: CGPoint(x: 176, y: canvasRect.height - 128))

        let headlineRect = CGRect(x: 78, y: canvasRect.height - 388, width: canvasRect.width - 156, height: 190)
        attributed(
            entry.headline,
            font: .systemFont(ofSize: canvasRect.width * 0.054, weight: .bold),
            color: evergreenDeep
        ).draw(with: headlineRect, options: [.usesLineFragmentOrigin, .usesFontLeading])

        let subtitleRect = CGRect(x: 78, y: canvasRect.height - 520, width: canvasRect.width - 180, height: 120)
        attributed(
            entry.subheadline,
            font: .systemFont(ofSize: canvasRect.width * 0.027, weight: .medium),
            color: muted
        ).draw(with: subtitleRect, options: [.usesLineFragmentOrigin, .usesFontLeading])

        let panelWidth = canvasRect.width * 0.82
        let panelHeight = canvasRect.height * 0.62
        let panelRect = CGRect(
            x: (canvasRect.width - panelWidth) / 2,
            y: canvasRect.height * 0.07,
            width: panelWidth,
            height: panelHeight
        )

        ctx.setShadow(offset: CGSize(width: 0, height: -16), blur: 34, color: nsColor(0x21463B, alpha: 0.12).cgColor)
        sandStrong.setFill()
        NSBezierPath(roundedRect: panelRect, xRadius: 46, yRadius: 46).fill()
        ctx.setShadow(offset: .zero, blur: 0, color: nil)

        let croppedImage = NSImage(cgImage: croppedCG, size: NSSize(width: croppedCG.width, height: croppedCG.height))
        let insetRect = panelRect.insetBy(dx: 18, dy: 18)
        let screenshotFrame = NSBezierPath(roundedRect: insetRect, xRadius: 38, yRadius: 38)
        screenshotFrame.addClip()
        croppedImage.draw(in: insetRect)

        outputImage.unlockFocus()

        guard let tiff = outputImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let png = bitmap.representation(using: .png, properties: [:]) else {
            fputs("Unable to encode composed screenshot for \(inputURL.path)\n", stderr)
            exit(1)
        }

        let outputDir = outputRootURL
            .appendingPathComponent(deviceClass)
            .appendingPathComponent(entry.language)
        try fileManager.createDirectory(at: outputDir, withIntermediateDirectories: true)
        let outputURL = outputDir.appendingPathComponent(String(format: "%02d-%@.png", entry.order, entry.scene))
        try png.write(to: outputURL)
    }
}
