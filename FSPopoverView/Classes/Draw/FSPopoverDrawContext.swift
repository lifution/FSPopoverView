//
//  FSPopoverDrawContext.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverDrawContext {
    
    var arrowSize: CGSize = .zero
    var arrowPoint: CGPoint = .zero
    var arrowDirection: FSPopoverView.ArrowDirection = .up
    
    var cornerRadius: CGFloat = 0.0
    var contentSize: CGSize = .zero
    var popoverSize: CGSize = .zero
    
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor?
    
    var shadowRadius: CGFloat = 0.0
    var shadowOpacity: Float = 1.0
    var shadowColor: UIColor?
    
    init () {}
}
