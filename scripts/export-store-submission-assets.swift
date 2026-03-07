import AppKit
import Foundation

struct ExportTarget {
    let name: String
    let sourceDeviceClass: String
    let width: Int
    let height: Int
}

let arguments = CommandLine.arguments
guard arguments.count == 3 else {
    fputs("Usage: export-store-submission-assets.swift <composed-root> <output-root>\n", stderr)
    exit(1)
}

let composedRootURL = URL(fileURLWithPath: arguments[1], isDirectory: true)
let outputRootURL = URL(fileURLWithPath: arguments[2], isDirectory: true)
let fileManager = FileManager.default

let targets = [
    ExportTarget(name: "6.7-inch", sourceDeviceClass: "6.7-inch", width: 1290, height: 2796),
    ExportTarget(name: "6.5-inch", sourceDeviceClass: "6.7-inch", width: 1242, height: 2688),
    ExportTarget(name: "5.5-inch", sourceDeviceClass: "6.1-inch", width: 1242, height: 2208)
]

let languages = ["en", "de"]
let scenes = [
    "01-dashboard.png",
    "02-addItem.png",
    "03-editItem.png",
    "04-archive.png",
    "05-settings.png"
]

func cropRect(for sourceSize: CGSize, targetAspectRatio: CGFloat) -> CGRect {
    let sourceAspectRatio = sourceSize.width / sourceSize.height

    if abs(sourceAspectRatio - targetAspectRatio) < 0.0001 {
        return CGRect(origin: .zero, size: sourceSize)
    }

    if sourceAspectRatio > targetAspectRatio {
        let cropWidth = sourceSize.height * targetAspectRatio
        let x = (sourceSize.width - cropWidth) / 2
        return CGRect(x: x, y: 0, width: cropWidth, height: sourceSize.height).integral
    }

    let cropHeight = sourceSize.width / targetAspectRatio
    let maxYOffset = max(0, sourceSize.height - cropHeight)
    let y = maxYOffset * 0.18
    return CGRect(x: 0, y: y, width: sourceSize.width, height: cropHeight).integral
}

for target in targets {
    for language in languages {
        let outputDir = outputRootURL
            .appendingPathComponent(target.name)
            .appendingPathComponent(language)
        try fileManager.createDirectory(at: outputDir, withIntermediateDirectories: true)

        for scene in scenes {
            let sourceURL = composedRootURL
                .appendingPathComponent(target.sourceDeviceClass)
                .appendingPathComponent(language)
                .appendingPathComponent(scene)

            guard let sourceImage = NSImage(contentsOf: sourceURL),
                  let sourceCG = sourceImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                fputs("Missing or unreadable composed screenshot: \(sourceURL.path)\n", stderr)
                exit(1)
            }

            let sourceSize = CGSize(width: sourceCG.width, height: sourceCG.height)
            let targetSize = NSSize(width: target.width, height: target.height)
            let targetAspectRatio = CGFloat(target.width) / CGFloat(target.height)
            let sourceRect = cropRect(for: sourceSize, targetAspectRatio: targetAspectRatio)

            guard let bitmap = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: target.width,
                pixelsHigh: target.height,
                bitsPerSample: 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: .deviceRGB,
                bitmapFormat: [],
                bytesPerRow: 0,
                bitsPerPixel: 0
            ) else {
                fputs("Unable to allocate bitmap for \(sourceURL.path)\n", stderr)
                exit(1)
            }

            bitmap.size = targetSize

            NSGraphicsContext.saveGraphicsState()
            guard let graphicsContext = NSGraphicsContext(bitmapImageRep: bitmap) else {
                fputs("Unable to create graphics context for \(sourceURL.path)\n", stderr)
                exit(1)
            }

            NSGraphicsContext.current = graphicsContext
            graphicsContext.imageInterpolation = .high

            NSColor.white.setFill()
            CGRect(origin: .zero, size: targetSize).fill()

            sourceImage.draw(
                in: CGRect(origin: .zero, size: targetSize),
                from: sourceRect,
                operation: .copy,
                fraction: 1.0,
                respectFlipped: true,
                hints: [.interpolation: NSImageInterpolation.high]
            )

            NSGraphicsContext.restoreGraphicsState()

            guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
                fputs("Unable to encode submission screenshot for \(sourceURL.path)\n", stderr)
                exit(1)
            }

            let outputURL = outputDir.appendingPathComponent(scene)
            try pngData.write(to: outputURL)
        }
    }
}
