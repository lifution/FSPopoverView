//
//  FSPopoverDrawer.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

protocol FSPopoverDrawer {
    
    init(context: FSPopoverDrawContext)
    
    func generatePath() -> UIBezierPath
    
    func generateBorderImage(with color: UIColor?, width: CGFloat) -> UIImage?
    
    func generateShadowImage(with color: UIColor?, radius: CGFloat, opacity: CGFloat) -> UIImage?
}
