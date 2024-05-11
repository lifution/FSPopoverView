//
//  FSPopoverViewTransitionFade.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public final class FSPopoverViewTransitionFade: FSPopoverViewAnimatedTransitioning {
    
    public init() {}
    
    public func animateTransition(transitionContext context: FSPopoverViewTransitionContext) {
        
        let popoverView = context.popoverView
        let dimBackgroundView = context.dimBackgroundView
        
        switch context.scene {
        case .present:
            popoverView.alpha = 0.0
            dimBackgroundView.alpha = 0.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.alpha = 1.0
                dimBackgroundView.alpha = 1.0
            } completion: { _ in
                context.completeTransition()
            }
        case .dismiss(_):
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
                popoverView.alpha = 0.0
                dimBackgroundView.alpha = 0.0
            } completion: { _ in
                popoverView.alpha = 1.0
                dimBackgroundView.alpha = 1.0
                context.completeTransition()
            }
        }
    }
}
