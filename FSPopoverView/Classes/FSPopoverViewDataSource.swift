//
//  FSPopoverViewDataSource.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/3.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

public protocol FSPopoverViewDataSource: AnyObject {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView?
    
    func contentView(for popoverView: FSPopoverView) -> UIView?
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize
}

/// Optional
public extension FSPopoverViewDataSource {
    func backgroundView(for popoverView: FSPopoverView) -> UIView? { return nil }
    func contentView(for popoverView: FSPopoverView) -> UIView? { return nil }
    func contentSize(for popoverView: FSPopoverView) -> CGSize { return .zero }
}
