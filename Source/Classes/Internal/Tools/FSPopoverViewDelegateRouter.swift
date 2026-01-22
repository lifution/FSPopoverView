//
//  FSPopoverViewDelegateRouter.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/13.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

final class FSPopoverViewDelegateRouter: NSObject {
    
    var gestureRecognizerShouldBeginHandler: ((_ gestureRecognizer: UIGestureRecognizer) -> Bool)?
    var gestureRecognizerShouldReceiveTouchHandler: ((_ gestureRecognizer: UIGestureRecognizer, _ touch: UITouch) -> Bool)?
}

extension FSPopoverViewDelegateRouter: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let handler = gestureRecognizerShouldBeginHandler {
            return handler(gestureRecognizer)
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let handler = gestureRecognizerShouldReceiveTouchHandler {
            return handler(gestureRecognizer, touch)
        }
        return false
    }
}
