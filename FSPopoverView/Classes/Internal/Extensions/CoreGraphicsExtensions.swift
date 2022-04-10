//
//  CoreGraphicsExtensions.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/9.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

private func _Flat<T: FloatingPoint>(_ x: T) -> T {
    guard
        x != T.leastNormalMagnitude,
        x != T.leastNonzeroMagnitude,
        x != T.greatestFiniteMagnitude
    else {
        return x
    }
    let scale: T = T(Int(UIScreen.main.scale))
    let flattedValue = ceil(x * scale) / scale
    return flattedValue
}

extension FSPopoverViewInternalWrapper where Base == CGRect {
    
    var flattedValue: CGRect {
        return .init(origin: base.origin.inner.flattedValue,
                     size: base.size.inner.flattedValue)
    }
}

extension FSPopoverViewInternalWrapper where Base == CGSize {
    
    var flattedValue: CGSize {
        return .init(width: base.width.inner.flattedValue,
                     height: base.height.inner.flattedValue)
    }
}

extension FSPopoverViewInternalWrapper where Base == CGPoint {
    
    var flattedValue: CGPoint {
        return .init(x: base.x.inner.flattedValue,
                     y: base.y.inner.flattedValue)
    }
}

extension FSPopoverViewInternalWrapper where Base == CGFloat {
    
    var flattedValue: CGFloat {
        return _Flat(base)
    }
}
