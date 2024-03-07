//
//  FSPopoverDrawUp.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawUp: FSPopoverDrawable {
    
    func generatePath(with context: FSPopoverDrawContext, offset: CGPoint) -> UIBezierPath {
        
        let popoverRect = CGRect(origin: offset, size: context.popoverSize)
        let contentRect = CGRect(origin: .init(x: popoverRect.minX, y: popoverRect.minY + context.arrowSize.height),
                                 size: context.contentSize)
        let arrowSize    = context.arrowSize.inner.flattedValue
        let arrowPoint   = context.arrowPoint.inner.offset(offset).inner.flattedValue
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
        if context.showsArrow {
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
