//
//  UIView+FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/13.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

extension FSPopoverViewInternalWrapper where Base: UIView {
    
    func makeMarginConstraints(to view: UIView) {
        base.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                           metrics: nil,
                                                           views: ["view": base]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                           metrics: nil,
                                                           views: ["view": base]))
    }
}
