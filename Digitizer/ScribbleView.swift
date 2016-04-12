//
//  ScribbleView.swift
//  Digitizer
//
//  Created by David Shoemaker on 4/10/16.
//
//

import UIKit

class ScribbleView: UIView {

    let path: UIBezierPath

    override init(frame: CGRect) {
        self.path = UIBezierPath()
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.path = UIBezierPath()
        super.init(coder:aDecoder)
    }

    override func drawRect(rect: CGRect) {
        self.path.lineJoinStyle = CGLineJoin.Round
        self.path.lineCapStyle = CGLineCap.Round
        self.path.lineWidth = 10.0
        UIColor.blackColor().setStroke()
        self.path.stroke()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.path.moveToPoint(touch.locationInView(self))
        }
        self.setNeedsDisplay()
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.path.addLineToPoint(touch.locationInView(self))
        }
        self.setNeedsDisplay()
    }

    internal func resetPath() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }

    internal func getImage() -> UIImage {
        let margin = CGFloat(0.7)
        let pathBounds = self.path.bounds
        var size = max(pathBounds.size.width, pathBounds.size.height)
        let dx = (size - pathBounds.size.width) / 2
        let dy = (size - pathBounds.size.height) / 2
        let marginpx = (margin * size) / 2
        size = size * (1.0 + margin)
        self.path.applyTransform(CGAffineTransformMakeTranslation(dx+marginpx-pathBounds.origin.x, dy+marginpx-pathBounds.origin.y))
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        UIColor.init(white:0.5, alpha:1.0).setFill()
        CGContextFillRect(context, CGRectMake(0, 0, size+1, size+1))

        let lineWidth = size * (18.0 / self.bounds.size.width)
        self.path.lineWidth = lineWidth
        UIColor.whiteColor().setStroke()
        self.path.stroke()

        let bigImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0, 20.0), false, 1.0)
        if let b = bigImage {
            b.drawInRect(CGRectMake(0, 0, 20, 20))
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
