//
//  FSPopoverDrawUp.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawUp: FSPopoverDrawer {
    
    let context: FSPopoverDrawContext
    
    init(context: FSPopoverDrawContext) {
        self.context = context
    }
    
    func generatePath() -> UIBezierPath {
        return _generate(offset: .zero)
    }
    
    func generateBorderImage(with color: UIColor?, width: CGFloat) -> UIImage? {
        
        let borderWidth = width * 2
        let size = CGSize(width: context.popoverSize.width + borderWidth * 2,
                          height: context.popoverSize.height + borderWidth * 2)
        
        // border image
        let borderImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            let path = _generate(offset: .init(x: borderWidth, y: borderWidth))
            path.lineWidth = borderWidth
            UIColor.red.setStroke()
            path.stroke()
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }()
        
        // mask image
        let maskImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            let path = _generate(offset: .init(x: borderWidth, y: borderWidth))
            UIColor.white.setFill()
            path.fill()
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }()
        
        // create image mask
        
        guard
            let cgimage = maskImage?.cgImage,
            let dataProvider = cgimage.dataProvider
        else {
            return nil
        }
        
        let bytesPerRow = cgimage.bytesPerRow
        let bitsPerPixel = cgimage.bitsPerPixel
        let width = cgimage.width
        let height = cgimage.height
        let bitsPerComponent = cgimage.bitsPerComponent
        
        guard
            let mask = CGImage(maskWidth: width,
                               height: height,
                               bitsPerComponent: bitsPerComponent,
                               bitsPerPixel: bitsPerPixel,
                               bytesPerRow: bytesPerRow,
                               provider: dataProvider,
                               decode: nil,
                               shouldInterpolate: false),
            let maskingCgImage = borderImage?.cgImage?.masking(mask)
        else {
            return nil
        }
        
        return UIImage(cgImage: maskingCgImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    func generateShadowImage(with color: UIColor?, radius: CGFloat, opacity: CGFloat) -> UIImage? {
        
        return nil
    }
}

private extension FSPopoverDrawUp {
    
    func _generate(offset: CGPoint) -> UIBezierPath {
        
        let popoverRect = CGRect(origin: offset, size: context.popoverSize)
        let contentRect = CGRect(origin: .init(x: popoverRect.minX, y: popoverRect.minY + context.arrowSize.height),
                                 size: context.contentSize)
        let arrowSize = context.arrowSize.inner.flattedValue
        let arrowPoint = context.arrowPoint.inner.offset(offset).inner.flattedValue
        let cornerRadius = context.cornerRadius.inner.flattedValue
        
        let path = UIBezierPath()
        // top-left
        do {
            path.move(to: .init(x: contentRect.minX, y: contentRect.minY + cornerRadius))
            path.addArc(withCenter: .init(x: contentRect.minX + cornerRadius, y: contentRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: .pi * 1.5,
                        clockwise: true)
        }
        // arrow
        do {
            path.addLine(to: .init(x: arrowPoint.x - arrowSize.width / 2, y: contentRect.minY))
            do {
                let controlPoint1 = CGPoint(x: arrowPoint.x - arrowSize.width / 4, y: contentRect.minY).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowPoint.x - arrowSize.width / 6, y: arrowPoint.y).inner.flattedValue
                path.addCurve(to: arrowPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            do {
                let controlPoint1 = CGPoint(x: arrowPoint.x + arrowSize.width / 6, y: arrowPoint.y).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowPoint.x + arrowSize.width / 4, y: contentRect.minY).inner.flattedValue
                path.addCurve(to: .init(x: arrowPoint.x + arrowSize.width / 2, y: contentRect.minY),
                              controlPoint1: controlPoint1,
                              controlPoint2: controlPoint2)
            }
        }
        // top-right
        do {
            path.addLine(to: .init(x: popoverRect.maxX - cornerRadius, y: contentRect.minY))
            path.addArc(withCenter: .init(x: contentRect.maxX - cornerRadius, y: contentRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 1.5,
                        endAngle: 0.0,
                        clockwise: true)
        }
        // bottom-right
        do {
            path.addLine(to: .init(x: contentRect.maxX, y: popoverRect.maxY - cornerRadius))
            path.addArc(withCenter: .init(x: contentRect.maxX - cornerRadius, y: popoverRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: 0.0,
                        endAngle: .pi * 0.5,
                        clockwise: true)
        }
        // bottom-left
        do {
            path.addLine(to: .init(x: popoverRect.minX + cornerRadius, y: popoverRect.maxY))
            path.addArc(withCenter: .init(x: popoverRect.minX + cornerRadius, y: popoverRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 0.5,
                        endAngle: .pi,
                        clockwise: true)
        }
        // close
        path.close()
        
        return path
    }
}
