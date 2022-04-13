//
//  FSPopoverViewDelegateRouter.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/13.
//  Copyright © 2022 Sheng. All rights reserved.
//

import UIKit

final class FSPopoverViewDelegateRouter: NSObject {
    
    var gestureRecognizerShouldBeginHandler: ((_ gestureRecognizer: UIGestureRecognizer) -> Bool)?
}

extension FSPopoverViewDelegateRouter: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let handler = gestureRecognizerShouldBeginHandler {
            return handler(gestureRecognizer)
        }
        return false
    }
}
