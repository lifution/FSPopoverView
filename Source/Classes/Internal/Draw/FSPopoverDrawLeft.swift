//
//  FSPopoverDrawLeft.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawLeft: FSPopoverDrawable {
    
    func generatePath(with context: FSPopoverDrawContext, offset: CGPoint) -> UIBezierPath {
        
        let popoverRect  = CGRect(origin: offset, size: context.popoverSize)
        let contentRect  = CGRect(origin: .init(x: popoverRect.minX + context.arrowSize.height, y: popoverRect.minY),
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
        // top-right
        do {
            path.addLine(to: .init(x: popoverRect.maxX - cornerRadius, y: contentRect.minY))
            path.addArc(withCenter: .init(x: popoverRect.maxX - cornerRadius, y: contentRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 1.5,
                        endAngle: 0.0,
                        clockwise: true)
        }
        // bottom-right
        do {
            path.addLine(to: .init(x: popoverRect.maxX, y: popoverRect.maxY - cornerRadius))
            path.addArc(withCenter: .init(x: popoverRect.maxX - cornerRadius, y: popoverRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: 0.0,
                        endAngle: .pi * 0.5,
                        clockwise: true)
        }
        // bottom-left
        do {
            path.addLine(to: .init(x: contentRect.minX + cornerRadius, y: contentRect.maxY))
            path.addArc(withCenter: .init(x: contentRect.minX + cornerRadius, y: contentRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 0.5,
                        endAngle: .pi,
                        clockwise: true)
        }
        // arrow
        if context.showsArrow {
            let arrowTopPoint = CGPoint(x: contentRect.minX, y: arrowPoint.y - arrowSize.width / 2).inner.flattedValue
            let arrowBottomPoint = CGPoint(x: contentRect.minX, y: arrowPoint.y + arrowSize.width / 2).inner.flattedValue
            path.addLine(to: arrowBottomPoint)
            do {
                let controlPoint1 = CGPoint(x: arrowBottomPoint.x, y: arrowBottomPoint.y - arrowSize.width / 4).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowPoint.x, y: arrowPoint.y + arrowSize.width / 6).inner.flattedValue
                path.addCurve(to: arrowPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            do {
                let controlPoint1 = CGPoint(x: arrowPoint.x, y: arrowPoint.y - arrowSize.width / 6).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowTopPoint.x, y: arrowTopPoint.y + arrowSize.width / 4).inner.flattedValue
                path.addCurve(to: arrowTopPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
        }
        // close
        path.close()
        
        return path
    }
}
