//
//  FSPopoverDrawer.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawer {
    
    // MARK: Properties/Internal
    
    let context: FSPopoverDrawContext
    
    // MARK: Properties/Private
    
    private let drawable: FSPopoverDrawable
    
    // MARK: Initialization
    
    init(context: FSPopoverDrawContext) {
        self.context = context
        switch context.arrowDirection {
        case .up:
            drawable = FSPopoverDrawUp()
        case .down:
            drawable = FSPopoverDrawDown()
        case .left:
            drawable = FSPopoverDrawLeft()
        case .right:
            drawable = FSPopoverDrawRight()
        }
    }
    
    // MARK: Internal
    
    func generatePath() -> UIBezierPath {
        return drawable.generatePath(with: context, offset: .zero)
    }
    
    func generateBorderImage() -> UIImage? {
        
        guard
            context.borderWidth > 0.0,
            let borderColor = context.borderColor
        else {
            return nil
        }
        
        // The border is clipped in half after drawing, so double here.
        let borderWidth = context.borderWidth * 2
        let size = CGSize(width: context.popoverSize.width + borderWidth * 2,
                          height: context.popoverSize.height + borderWidth * 2)
        
        // border image
        let borderImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            let path = drawable.generatePath(with: context, offset: .init(x: borderWidth, y: borderWidth))
            path.lineWidth = borderWidth
            borderColor.setStroke()
            path.stroke()
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }()
        
        // mask image
        let maskImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            let path = drawable.generatePath(with: context, offset: .init(x: borderWidth, y: borderWidth))
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
        
        let bytesPerRow  = cgimage.bytesPerRow
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
    
    func generateShadowImage() -> UIImage? {
        
        guard
            context.shadowRadius > 0.0,
            context.shadowOpacity > 0.0,
            let shadowColor = context.shadowColor
        else {
            return nil
        }
        
        // The shadow area is gradually reduced from the inside to the outside,
        // and the visible part of the shadow is a bit larger than the set `shadowRadius`,
        // so it is increased here to avoid clipping the shadow.
        let radius = context.shadowRadius + context.borderWidth
        let inset  = radius + 10.0
        let size   = CGSize(width: context.popoverSize.width + inset * 2,
                            height: context.popoverSize.height + inset * 2)
        
        // shadow image
        let shadowImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            
            let path = drawable.generatePath(with: self.context, offset: .init(x: inset, y: inset))
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.white.cgColor
            layer.shadowColor = shadowColor.cgColor
            layer.shadowRadius = radius
            layer.shadowOffset = .zero
            layer.shadowOpacity = min(1.0, self.context.shadowOpacity)
            layer.magnificationFilter = .nearest
            layer.render(in: context)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }()
        
        // mask image
        let maskImage: UIImage? = {
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            
            let path = drawable.generatePath(with: context, offset: .init(x: inset, y: inset))
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
        
        let bytesPerRow  = cgimage.bytesPerRow
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
            let maskingCgImage = shadowImage?.cgImage?.masking(mask)
        else {
            return nil
        }
        
        let layer = CALayer()
        layer.bounds = .init(origin: .zero, size: size)
        layer.contents = maskingCgImage
        layer.contentsScale = UIScreen.main.scale
        layer.magnificationFilter = .nearest
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
