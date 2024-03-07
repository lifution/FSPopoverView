//
//  FSPopoverDrawDown.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawDown: FSPopoverDrawable {
    
    func generatePath(with context: FSPopoverDrawContext, offset: CGPoint) -> UIBezierPath {
        
        let popoverRect  = CGRect(origin: offset, size: context.popoverSize)
        let contentRect  = CGRect(origin: offset, size: context.contentSize)
        let arrowSize    = context.arrowSize.inner.flattedValue
        let arrowPoint   = context.arrowPoint.inner.offset(offset).inner.flattedValue
        let cornerRadius = context.cornerRadius.inner.flattedValue
        
        let path = UIBezierPath()
        // top-left
        do {
            path.move(to: .init(x: popoverRect.minX, y: popoverRect.minY + cornerRadius))
            path.addArc(withCenter: .init(x: popoverRect.minX + cornerRadius, y: popoverRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: .pi * 1.5,
                        clockwise: true)
        }
        // top-right
        do {
            path.addLine(to: .init(x: popoverRect.maxX - cornerRadius, y: popoverRect.minY))
            path.addArc(withCenter: .init(x: popoverRect.maxX - cornerRadius, y: popoverRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 1.5,
                        endAngle: 0.0,
                        clockwise: true)
        }
        // bottom-right
        do {
            path.addLine(to: .init(x: popoverRect.maxX, y: contentRect.maxY - cornerRadius))
            path.addArc(withCenter: .init(x: popoverRect.maxX - cornerRadius, y: contentRect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: 0.0,
                        endAngle: .pi * 0.5,
                        clockwise: true)
        }
        // arrow
        if context.showsArrow {
            let arrowLeftPoint = CGPoint(x: arrowPoint.x - arrowSize.width / 2, y: contentRect.maxY).inner.flattedValue
            let arrowRightPoint = CGPoint(x: arrowPoint.x + arrowSize.width / 2, y: contentRect.maxY).inner.flattedValue
            path.addLine(to: arrowRightPoint)
            do {
                let controlPoint1 = CGPoint(x: arrowRightPoint.x - arrowSize.width / 4, y: arrowRightPoint.y).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowPoint.x + arrowSize.width / 6, y: arrowPoint.y).inner.flattedValue
                path.addCurve(to: arrowPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            do {
                let controlPoint1 = CGPoint(x: arrowPoint.x - arrowSize.width / 6, y: arrowPoint.y).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowLeftPoint.x + arrowSize.width / 4, y: arrowLeftPoint.y).inner.flattedValue
                path.addCurve(to: arrowLeftPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
        }
        // bottom-left
        do {
            path.addLine(to: .init(x: popoverRect.minX + cornerRadius, y: contentRect.maxY))
            path.addArc(withCenter: .init(x: popoverRect.minX + cornerRadius, y: contentRect.maxY - cornerRadius),
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
