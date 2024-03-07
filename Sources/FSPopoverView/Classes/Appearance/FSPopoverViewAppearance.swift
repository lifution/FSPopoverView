//
//  FSPopoverViewAppearance.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/12/2.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

public final class FSPopoverViewAppearance {
    
    // MARK: Properties/Public
    
    public var showsArrow: Bool
    public var showsDimBackground: Bool
    public var cornerRadius: CGFloat
    public var arrowSize: CGSize
    public var borderWidth: CGFloat
    public var borderColor: UIColor?
    public var shadowColor: UIColor?
    public var shadowRadius: CGFloat
    public var shadowOpacity: Float
    public var backgroundColor: UIColor?
    // list
    public var spacing: CGFloat
    public var textFont: UIFont
    public var textColor: UIColor?
    public var separatorInset: UIEdgeInsets
    public var separatorColor: UIColor?
    public var highlightedColor: UIColor?
    
    // MARK: Initialization
    
    static let shared = FSPopoverViewAppearance()
    
    private init() {
        showsArrow = true
        showsDimBackground = false
        cornerRadius = 8.0
        arrowSize = .init(width: 22.0, height: 10.0)
        borderWidth = 1.0
        shadowRadius = 3.0
        shadowOpacity = 0.68
        spacing = 6.0
        textFont = .systemFont(ofSize: 18.0)
        separatorInset = .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        // colors
        if #available(iOS 13.0, *) {
            borderColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "423E55")!
                }
                return .inner.color(hexed: "CFCFCF")!
            })
            shadowColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "E8E8E8")!
                }
                return .inner.color(hexed: "696969")!
            })
            backgroundColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "1A172B")!
                }
                return .white
            })
            textColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "E8E8E8")!
                }
                return .black
            })
            separatorColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "4E4A64")!
                }
                return .lightGray
            })
            highlightedColor = UIColor(dynamicProvider: { trait in
                if trait.userInterfaceStyle == .dark {
                    return .inner.color(hexed: "#322F47")!
                }
                return .black.withAlphaComponent(0.1)
            })
        } else {
            borderColor = .inner.color(hexed: "CFCFCF")!
            shadowColor = .inner.color(hexed: "696969")!
            backgroundColor = .white
            textColor = .black
            separatorColor = .lightGray
            highlightedColor = .black.withAlphaComponent(0.1)
        }
    }
}
