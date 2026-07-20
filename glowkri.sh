glowkri() { swift - "$1" "${1%.*}-hdr.jpg" <<'SW'
import Foundation; import CoreGraphics; import ImageIO; import UniformTypeIdentifiers
let a = CommandLine.arguments
guard a.count >= 3, let s = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[1]) as CFURL, nil),
      let c = CGImageSourceCreateImageAtIndex(s, 0, nil) else { print("usage: glowkri image.png"); exit(1) }
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
CGImageDestinationFinalize(d); print("✅ glowkri ->", a[2])
SW
}
glowkri "$1"
