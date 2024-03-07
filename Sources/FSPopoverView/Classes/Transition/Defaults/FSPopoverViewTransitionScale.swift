//
//  FSPopoverViewTransitionScale.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/15.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public final class FSPopoverViewTransitionScale: FSPopoverViewAnimatedTransitioning {
    
    public var usingSpring = true
    
    public init() {}
    
    public func animateTransition(transitionContext context: FSPopoverViewTransitionContext) {
        
        let popoverView = context.popoverView
        let arrowPoint = popoverView.arrowPoint
        let dimBackgroundView = context.dimBackgroundView
        
        // anchor point
        do {
            let frame = popoverView.frame
            popoverView.layer.anchorPoint = {
                var x: CGFloat = 0.0, y: CGFloat = 0.0
                let arrowPointInPopover = CGPoint(x: arrowPoint.x - frame.minX, y: arrowPoint.y - frame.minY)
                switch popoverView.arrowDirection {
                case .up:
                    x = arrowPointInPopover.x / frame.width
                case .down:
                    x = arrowPointInPopover.x / frame.width
                    y = 1.0
                case .left:
                    y = arrowPointInPopover.y / frame.height
                case .right:
                    x = 1.0
                    y = arrowPointInPopover.y / frame.height
                }
                return .init(x: x, y: y)
            }()
            // Needs to reset frame again after updating `layer.anchorPoint`,
            // or the popover view will be in the wrong place.
            popoverView.frame = frame
        }
        
        switch context.scene {
        case .present:
            dimBackgroundView.alpha = 0.0
            UIView.animate(withDuration: 0.18, delay: 0.0, options: .curveEaseOut) {
                dimBackgroundView.alpha = 1.0
            }
            
            popoverView.transform = .init(scaleX: 0.01, y: 0.01)
            let duration: TimeInterval = usingSpring ? 0.38 : 0.18
            let spring: CGFloat = usingSpring ? 0.68 : 1.0
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: spring, initialSpringVelocity: 0.5) {
                popoverView.transform = .identity
            } completion: { _ in
                context.completeTransition()
            }
        case .dismiss(let isSelection):
            UIView.animate(withDuration: isSelection ? 0.25 : 0.18, delay: 0.0, options: .curveEaseOut) {
                popoverView.alpha = 0.0
                dimBackgroundView.alpha = 0.0
                if !isSelection {
                    popoverView.transform = .init(scaleX: 0.01, y: 0.01)
                }
            } completion: { _ in
                popoverView.alpha = 1.0
                popoverView.transform = .identity
                dimBackgroundView.alpha = 1.0
                context.completeTransition()
            }
        }
    }
}
