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
    
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets
    
    func popoverViewShouldHideOnTapOutside(_ popoverView: FSPopoverView) -> Bool
}

/// Optional
public extension FSPopoverViewDataSource {
    func backgroundView(for popoverView: FSPopoverView) -> UIView? { return nil }
    func contentView(for popoverView: FSPopoverView) -> UIView? { return nil }
    func contentSize(for popoverView: FSPopoverView) -> CGSize { return .zero }
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        return .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    func popoverViewShouldHideOnTapOutside(_ popoverView: FSPopoverView) -> Bool { return true }
}
