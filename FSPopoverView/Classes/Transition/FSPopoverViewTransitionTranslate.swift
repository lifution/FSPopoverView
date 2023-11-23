//
//  FSPopoverViewTransitionTranslate.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public final class FSPopoverViewTransitionTranslate: FSPopoverViewAnimatedTransitioning {
    
    public init() {}
    
    public func animateTransition(transitionContext context: FSPopoverViewTransitionContext) {
        
        guard let containerView = context.popoverView.containerView else {
            context.completeTransition()
            return
        }
        
        let popoverView = context.popoverView
        let dimBackgroundView = context.dimBackgroundView
        
        let popoverFrame = popoverView.frame
        let containerFrame = containerView.frame
        let popoverInitialFrame: CGRect = {
            var frame = popoverFrame
            switch context.arrowDirection {
            case .up:
                frame.origin.y = containerFrame.maxY
            case .down:
                frame.origin.y = containerFrame.minY - frame.height
            case .left:
                frame.origin.x = containerFrame.maxX
            case .right:
                frame.origin.x = containerFrame.minX - frame.width
            }
            return frame
        }()
        
        switch context.scene {
        case .present:
            popoverView.frame = popoverInitialFrame
            dimBackgroundView.alpha = 0.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.frame = popoverFrame
                dimBackgroundView.alpha = 1.0
            } completion: { _ in
                context.completeTransition()
            }
        case .dismiss:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.frame = popoverInitialFrame
                dimBackgroundView.alpha = 0.0
            } completion: { _ in
                context.completeTransition()
            }
        case .selection:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.alpha = 0.0
                dimBackgroundView.alpha = 0.0
            } completion: { _ in
                context.completeTransition()
            }
        }
    }
}
