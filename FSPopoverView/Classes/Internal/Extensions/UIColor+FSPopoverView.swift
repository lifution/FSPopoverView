//
//  UIColor+FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/12/2.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

extension FSPopoverViewInternalWrapper where Base: UIColor {
    
    static func color(hexed hex: String) -> UIColor? {
        
        guard hex.count > 0 else {
            return nil
        }
        
        var colorString = hex.uppercased()
        do {
            // remove prefix `#` / `0x`。
            if colorString.hasPrefix("#") {
                colorString.removeFirst()
            } else if colorString.hasPrefix("0x") {
                colorString.removeFirst(2)
            } else if colorString.hasPrefix("0X") {
                colorString.removeFirst(2)
            }
        }
        
        if colorString.isEmpty {
            return nil
        }
        
        func _colorComponent(from string: String, location: Int, length: Int) -> CGFloat {
            let startIndex = string.index(string.startIndex, offsetBy: location)
            let endIndex = string.index(startIndex, offsetBy: length)
            let substring = String(string[startIndex..<endIndex])
            guard !substring.isEmpty else {
                return 0.0
            }
            let fullHex = (length == 2) ? substring : (substring + substring)
            var hexValue: UInt32 = 0
            if Scanner(string: fullHex).scanHexInt32(&hexValue) {
                return CGFloat(hexValue) / 255.0
            }
            return 0.0
        }
        
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 0.0
        
        switch colorString.count {
        case 3: // #RGB
            alpha = 1.0
            red   = _colorComponent(from: colorString, location: 0, length: 1)
            green = _colorComponent(from: colorString, location: 1, length: 1)
            blue  = _colorComponent(from: colorString, location: 2, length: 1)
        case 4: // #ARGB
            alpha = _colorComponent(from: colorString, location: 0, length: 1)
            red   = _colorComponent(from: colorString, location: 1, length: 1)
            green = _colorComponent(from: colorString, location: 2, length: 1)
            blue  = _colorComponent(from: colorString, location: 3, length: 1)
        case 6: // #RRGGBB
            alpha = 1.0
            red   = _colorComponent(from: colorString, location: 0, length: 2)
            green = _colorComponent(from: colorString, location: 2, length: 2)
            blue  = _colorComponent(from: colorString, location: 4, length: 2)
        case 8: // #AARRGGBB
            alpha = _colorComponent(from: colorString, location: 0, length: 2)
            red   = _colorComponent(from: colorString, location: 2, length: 2)
            green = _colorComponent(from: colorString, location: 4, length: 2)
            blue  = _colorComponent(from: colorString, location: 6, length: 2)
        default:
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
