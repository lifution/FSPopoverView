//
//  FSPopoverViewTransitionContext.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public final class FSPopoverViewTransitionContext {
    
    // MARK: Sence
    
    public enum Scene {
        
        case present
        
        /// - Prameters:
        ///   - isSelection: This value is usually used in a list.
        case dismiss(_ isSelection: Bool = false)
    }
    
    // MARK: Properties/Public
    
    public let scene: FSPopoverViewTransitionContext.Scene
    
    public let popoverView: FSPopoverView
    
    public let dimBackgroundView: UIView
    
    // MARK: Properties/Internal
    
    var onDidCompleteTransition: (() -> Void)?
    
    // MARK: Initialization
    
    init(scene: FSPopoverViewTransitionContext.Scene, popoverView: FSPopoverView, dimBackgroundView: UIView) {
        self.scene = scene
        self.popoverView = popoverView
        self.dimBackgroundView = dimBackgroundView
    }
    
    // MARK: Public
    
    /// When the animation ends, you must call this method to
    /// tell the popover view that the animation has ended.
    public func completeTransition() {
        onDidCompleteTransition?()
    }
}
