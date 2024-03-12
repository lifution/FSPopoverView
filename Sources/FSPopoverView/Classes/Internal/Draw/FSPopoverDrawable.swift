//
//  FSPopoverDrawable.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/12.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

protocol FSPopoverDrawable {
    func generatePath(with context: FSPopoverDrawContext, offset: CGPoint) -> UIBezierPath
}
