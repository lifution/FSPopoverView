//
//  FSPopoverListCell.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// Abstract base class, cannot be used directly, must be inherited for use.
open class FSPopoverListCell: UIView {
    
    // MARK: Properties/Public
    
    public let item: FSPopoverListItem
    
    // MARK: Properties/Private
    
    private let separatorView = _FSSeparatorView()
    
    private var separatorConstraints = [NSLayoutConstraint]()
    
    // MARK: Initialization
    
    public required init(item: FSPopoverListItem) {
        #if DEBUG
        let abstractName = String(describing: FSPopoverListCell.self)
        if "\(type(of: self))" == abstractName {
            fatalError("\(abstractName) is abstract base class, cannot be used directly, must be inherited for use.")
        }
        #endif
        self.item = item
        super.init(frame: .zero)
        p_didInitialize()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(separatorView)
    }
    
    // MARK: Private
    
    private func p_didInitialize() {
        defer {
            didInitialize()
        }
        backgroundColor = .clear
        separatorView.isHidden = true
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
    }
    
    // MARK: Open
    
    /// Invoked after initialization.
    /// Subclass can do initialization work in this method.
    open func didInitialize() {}
    
    /// update contents.
    ///
    /// - Subclass can update contents in this method.
    /// - This method will be called when the item that binding
    ///   with current view calls method `reload(_:)`.
    /// - ⚠️ Subclasses **must** call `super.renderContents()` when
    ///   overriding this method, otherwise some bugs may occur.
    ///
    open func renderContents() {
        defer { p_remakeConstraints() }
        separatorView.color = item.separatorColor
        separatorView.isHidden = item.isSeparatorHidden
    }
}

// MARK: - Private

private extension FSPopoverListCell {
    
    func p_remakeConstraints() {
        NSLayoutConstraint.deactivate(separatorConstraints)
        separatorConstraints.removeAll()
        switch item.scrollDireciton {
        case .vertical:
            let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[view]-right-|",
                                                              metrics: [
                                                                "left": item.separatorInset.left,
                                                                "right": item.separatorInset.right
                                                              ],
                                                              views: ["view": separatorView])
            let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==height)]|",
                                                              metrics: ["height": 1.0 / UIScreen.main.scale],
                                                              views: ["view": separatorView])
            separatorConstraints += hConstraints + vConstraints
        case .horizontal:
            let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==width)]|",
                                                              metrics: ["width": 1.0 / UIScreen.main.scale],
                                                              views: ["view": separatorView])
            let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|",
                                                              metrics: [
                                                                "top": item.separatorInset.top,
                                                                "bottom": item.separatorInset.bottom
                                                              ],
                                                              views: ["view": separatorView])
            separatorConstraints += hConstraints + vConstraints
        }
        addConstraints(separatorConstraints)
    }
}
