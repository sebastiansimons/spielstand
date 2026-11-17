// Renders the 1024x1024 app icon: teal/coral split background (the two team colors)
// with a basketball in the middle. Run: swift Tools/make_icon.swift <output.png>
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let size = 1024.0
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon.png"

let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8,
                    bytesPerRow: 0, space: space,
                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!

func rgb(_ r: Double, _ g: Double, _ b: Double) -> CGColor {
    CGColor(srgbRed: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

let teal = rgb(15, 110, 86)
let coral = rgb(153, 60, 29)
let ball = rgb(240, 134, 40)
let seam = rgb(40, 22, 10)

// Background halves
ctx.setFillColor(teal)
ctx.fill(CGRect(x: 0, y: 0, width: size / 2, height: size))
ctx.setFillColor(coral)
ctx.fill(CGRect(x: size / 2, y: 0, width: size / 2, height: size))

// Ball
let c = CGPoint(x: size / 2, y: size / 2)
let r = 330.0
let ballRect = CGRect(x: c.x - r, y: c.y - r, width: 2 * r, height: 2 * r)

// Light ring separating the ball from the background
ctx.setFillColor(rgb(255, 255, 255))
ctx.fillEllipse(in: ballRect.insetBy(dx: -22, dy: -22))

ctx.setFillColor(ball)
ctx.fillEllipse(in: ballRect)

// Seams, clipped to the ball
ctx.saveGState()
ctx.addEllipse(in: ballRect)
ctx.clip()
ctx.setStrokeColor(seam)
ctx.setLineWidth(26)
ctx.setLineCap(.round)

// Vertical and horizontal seams
ctx.move(to: CGPoint(x: c.x, y: c.y - r)); ctx.addLine(to: CGPoint(x: c.x, y: c.y + r))
ctx.move(to: CGPoint(x: c.x - r, y: c.y)); ctx.addLine(to: CGPoint(x: c.x + r, y: c.y))
ctx.strokePath()

// Curved side seams: arcs of large circles centered outside the ball
let off = r * 1.25
let arcR = r * 0.95
ctx.addArc(center: CGPoint(x: c.x - off, y: c.y), radius: arcR, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: false)
ctx.strokePath()
ctx.addArc(center: CGPoint(x: c.x + off, y: c.y), radius: arcR, startAngle: .pi / 2, endAngle: 3 * .pi / 2, clockwise: false)
ctx.strokePath()
ctx.restoreGState()

// Outline
ctx.setStrokeColor(seam)
ctx.setLineWidth(18)
ctx.strokeEllipse(in: ballRect.insetBy(dx: 9, dy: 9))

let image = ctx.makeImage()!
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL,
                                           UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, image, nil)
CGImageDestinationFinalize(dest)
print("Wrote \(out)")
