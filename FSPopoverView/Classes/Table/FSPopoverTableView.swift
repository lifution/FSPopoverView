//
//  FSPopoverTableView.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/2.
//  Copyright (c) 2022 Sheng. All rights reserved.
//

import UIKit

open class FSPopoverTableView: FSPopoverView {
    
    // MARK: Properties/Public
    
    
    
    // MARK: Properties/Private
    
    
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
}

// MARK: - Override

extension FSPopoverTableView {
    
    open override func setNeedsReload() {
        
    }
}

// MARK: - Private

private extension FSPopoverTableView {
    
    /// Invoked after initialization.
    func p_didInitialize() {
        
    }
}
