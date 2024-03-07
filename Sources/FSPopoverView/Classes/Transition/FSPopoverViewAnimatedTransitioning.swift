//
//  FSPopoverViewAnimatedTransitioning.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/15.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSPopoverViewAnimatedTransitioning: AnyObject {
    
    /// This method will be called when presenting or dismissing a popover view.
    /// Use this method to configure the animations associated with your custom transition.
    ///
    /// - Important:
    ///   * You must call the method `completeTransition()` of `context` when the transition is finished.
    ///     Otherwise the popover view will work unexpected.
    ///
    func animateTransition(transitionContext context: FSPopoverViewTransitionContext)
}
