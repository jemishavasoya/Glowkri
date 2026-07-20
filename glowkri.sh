#!/bin/bash

# ==============================================================================
# Glowkri - LinkedIn Glowing HDR Logo Generator
# https://github.com/jemishavasoya/Glowkri
# ==============================================================================

echo "========================================="
echo "🌟 Glowkri - HDR Logo Generator"
echo "========================================="
echo ""

# Check if argument is provided, otherwise prompt user for input
IMAGE_PATH="$1"
if [ -z "$IMAGE_PATH" ]; then
    echo "👉 Please drag and drop your logo file here, then press Enter:"
    read -r IMAGE_PATH
fi

# Clean up path (removes quotes and trailing spaces if user dragged and dropped)
IMAGE_PATH="${IMAGE_PATH%"${IMAGE_PATH##*[![:space:]]}"}"
IMAGE_PATH="${IMAGE_PATH//\\ / }"
IMAGE_PATH="${IMAGE_PATH#\'}"
IMAGE_PATH="${IMAGE_PATH%\'}"
IMAGE_PATH="${IMAGE_PATH#\"}"
IMAGE_PATH="${IMAGE_PATH%\"}"

if [ ! -f "$IMAGE_PATH" ]; then
    echo "❌ Error: File not found at path: '$IMAGE_PATH'"
    exit 1
fi

echo "⚙️  Processing your logo..."
OUTPUT_PATH="${IMAGE_PATH%.*}-hdr.jpg"

swift - "$IMAGE_PATH" "$OUTPUT_PATH" <<'SW'
import Foundation; import CoreGraphics; import ImageIO; import UniformTypeIdentifiers
let a = CommandLine.arguments
guard a.count >= 3, let s = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[1]) as CFURL, nil),
      let c = CGImageSourceCreateImageAtIndex(s, 0, nil) else { print("❌ Invalid image format"); exit(1) }
let w = c.width, h = c.height, r = w * 4
var b = [UInt8](repeating: 0, count: r * h)
let x = CGContext(data: &b, width: w, height: h, bitsPerComponent: 8, bytesPerRow: r,
      space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
x.setFillColor(red: 1, green: 1, blue: 1, alpha: 1); x.fill(CGRect(x: 0, y: 0, width: w, height: h))
x.draw(c, in: CGRect(x: 0, y: 0, width: w, height: h))
let img = CGImage(width: w, height: h, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: r,
      space: CGColorSpace(name: CGColorSpace.itur_2100_PQ)!,
      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
      provider: CGDataProvider(data: Data(b) as CFData)!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
let d = CGImageDestinationCreateWithURL(URL(fileURLWithPath: a[2]) as CFURL, UTType.jpeg.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(d, img, [kCGImageDestinationLossyCompressionQuality: 0.95] as CFDictionary)
CGImageDestinationFinalize(d)
SW

echo ""
echo "✅ SUCCESS: Your glowing HDR logo is ready!"
echo "📁 Saved at: $OUTPUT_PATH"
echo ""
echo "⭐ Star the project on GitHub: https://github.com/jemishavasoya/Glowkri"
echo "☕ Buy me a coffee: https://www.buymeacoffee.com/jempatellbv"
echo "========================================="
