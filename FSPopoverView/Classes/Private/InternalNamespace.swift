//
//  InternalNamespace.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/9.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

struct FSPopoverViewInternalWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol FSPopoverViewInternalCompatible: AnyObject {}
extension FSPopoverViewInternalCompatible {
    public static var inner: FSPopoverViewInternalWrapper<Self>.Type {
        get { return FSPopoverViewInternalWrapper<Self>.self }
        set {}
    }
    public var inner: FSPopoverViewInternalWrapper<Self> {
        get { return FSPopoverViewInternalWrapper(self) }
        set {}
    }
}

protocol FSPopoverViewInternalCompatibleValue {}
extension FSPopoverViewInternalCompatibleValue {
    static var inner: FSPopoverViewInternalWrapper<Self>.Type {
        get { return FSPopoverViewInternalWrapper<Self>.self }
        set {}
    }
    var inner: FSPopoverViewInternalWrapper<Self> {
        get { return FSPopoverViewInternalWrapper(self) }
        set {}
    }
}

extension UIView: FSPopoverViewInternalCompatible {}

extension CGRect: FSPopoverViewInternalCompatibleValue {}
extension CGSize: FSPopoverViewInternalCompatibleValue {}
extension CGPoint: FSPopoverViewInternalCompatibleValue {}
extension CGFloat: FSPopoverViewInternalCompatibleValue {}
