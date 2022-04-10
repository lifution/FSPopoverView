//
//  FSPopoverDrawRight.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawRight: FSPopoverDrawer {
    
    func draw(with context: FSPopoverDrawContext) -> UIBezierPath {
        
        let rect = CGRect(origin: .zero, size: context.popoverSize)
        let contentRect = CGRect(origin: .zero, size: context.contentSize)
        let arrowSize = context.arrowSize.inner.flattedValue
        let arrowPoint = context.arrowPoint.inner.flattedValue
        let cornerRadius = context.cornerRadius.inner.flattedValue
        
        let path = UIBezierPath()
        // top-left
        do {
            path.move(to: .init(x: 0.0, y: cornerRadius))
            path.addArc(withCenter: .init(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: .pi * 1.5,
                        clockwise: true)
        }
        // top-right
        do {
            path.addLine(to: .init(x: contentRect.maxX - cornerRadius, y: 0.0))
            path.addArc(withCenter: .init(x: contentRect.maxX - cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 1.5,
                        endAngle: 0.0,
                        clockwise: true)
        }
        // arrow
        do {
            let arrowTopPoint = CGPoint(x: contentRect.maxX, y: arrowPoint.y - arrowSize.width / 2).inner.flattedValue
            let arrowBottomPoint = CGPoint(x: contentRect.maxX, y:  arrowPoint.y + arrowSize.width / 2).inner.flattedValue
            path.addLine(to: arrowTopPoint)
            do {
                let controlPoint1 = CGPoint(x: arrowTopPoint.x, y: arrowTopPoint.y + arrowSize.width / 4).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowPoint.x, y: arrowPoint.y - arrowSize.width / 6).inner.flattedValue
                path.addCurve(to: arrowPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            do {
                let controlPoint1 = CGPoint(x: arrowPoint.x, y: arrowPoint.y + arrowSize.width / 6).inner.flattedValue
                let controlPoint2 = CGPoint(x: arrowBottomPoint.x, y: arrowBottomPoint.y - arrowSize.width / 4).inner.flattedValue
                path.addCurve(to: arrowBottomPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
        }
        // bottom-right
        do {
            path.addLine(to: .init(x: contentRect.maxX, y: rect.height - cornerRadius))
            path.addArc(withCenter: .init(x: contentRect.maxX - cornerRadius, y: rect.height - cornerRadius),
                        radius: cornerRadius,
                        startAngle: 0.0,
                        endAngle: .pi * 0.5,
                        clockwise: true)
        }
        // bottom-left
        do {
            path.addLine(to: .init(x: cornerRadius, y: rect.height))
            path.addArc(withCenter: .init(x: cornerRadius, y: rect.height - cornerRadius),
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
