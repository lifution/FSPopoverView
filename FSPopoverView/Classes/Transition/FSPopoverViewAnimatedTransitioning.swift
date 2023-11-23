//
//  FSPopoverViewAnimatedTransitioning.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/15.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSPopoverViewAnimatedTransitioning: AnyObject {
    
    func animateTransition(transitionContext: FSPopoverViewTransitionContext)
}
