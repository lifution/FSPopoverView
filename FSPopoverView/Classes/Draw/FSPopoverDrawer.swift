//
//  FSPopoverDrawer.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/10.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

protocol FSPopoverDrawer {
    func draw(with context: FSPopoverDrawContext) -> UIBezierPath
}
