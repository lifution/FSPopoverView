//
//  FSPopoverDrawUp.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawUp: FSPopoverDrawer {
    
    func draw(with context: FSPopoverDrawContext) -> UIBezierPath {
        
        let rect = CGRect(origin: .zero, size: context.popoverSize)
        let contentRect = CGRect(origin: .init(x: 0.0, y: context.arrowSize.height),
                                 size: context.contentSize)
        let arrowSize = context.arrowSize.inner.flattedValue
        let arrowPoint = context.arrowPoint.inner.flattedValue
        let cornerRadius = context.cornerRadius.inner.flattedValue
        
        let path = UIBezierPath()
        // top-left
        do {
            path.move(to: .init(x: 0.0, y: contentRect.minY + cornerRadius))
            path.addArc(withCenter: .init(x: cornerRadius, y: contentRect.minY + cornerRadius),
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
            path.addLine(to: .init(x: rect.width - cornerRadius, y: contentRect.minY))
            path.addArc(withCenter: .init(x: contentRect.maxX - cornerRadius, y: contentRect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi * 1.5,
                        endAngle: 0.0,
                        clockwise: true)
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
