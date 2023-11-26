//
//  _FSSeparatorView.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/24.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

final class _FSSeparatorView: UIView {
    
    // MARK: Properties/Open
    
    var color: UIColor? {
        didSet {
            colorLayer.backgroundColor = color?.cgColor
        }
    }
    
    // MARK: Properties/Override
    
    @available(*, unavailable)
    override var backgroundColor: UIColor? {
        get { return nil }
        set { super.backgroundColor = nil }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17, *) {} else {
            colorLayer.backgroundColor = color?.cgColor
        }
    }
    
    // MARK: Properties/Private
    
    private let colorLayer = CAShapeLayer()
    
    // MARK: Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorLayer.frame = .init(origin: .zero, size: frame.size)
    }
    
    // MARK: Private
    
    private func p_didInitialize() {
        color = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        layer.addSublayer(colorLayer)
        if #available(iOS 17, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.colorLayer.backgroundColor = self.color?.cgColor
            }
        }
    }
}
