//
//  FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/2.
//  Copyright (c) 2022 Sheng. All rights reserved.
//

import UIKit

open class FSPopoverView: UIView {
    
    // MARK: Properties/Open
    
    /// The object that acts as the data source of the popover view.
    ///
    /// * The data source must adopt the FSPopoverViewDataSource protocol.
    /// * The data source is not retained.
    ///
    weak open var dataSource: FSPopoverViewDataSource? {
        didSet {
            setNeedsReload()
        }
    }
    
    // MARK: Properties/Private
    
    private var needsReload = false
    
    private var backgroundView: UIView?
    
    private var contentView: UIView?
    
    #warning("TEST")
    private lazy var displayWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .statusBar - 1
        window.backgroundColor = .init(white: 0.0, alpha: 0.38)
        return window
    }()
    
    // MARK: Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions/Open
    
    /// Tells the popover view to reload all of its contents.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.setNeedsReload()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * This method makes a note of the request and returns immediately. Because this
    ///       method does not force an immediate reload, all of the contents will reload in
    ///       view's next layout update cycle. This behavior allows you to consolidate all
    ///       of your content reloads to one layout update cycle, which is usually better for
    ///       performance.
    ///     * You should call this method on the main thread.
    ///
    @objc dynamic open func setNeedsReload() {
        guard Thread.isMainThread else {
            #if DEBUG
            fatalError("You should call this method on the main thread.")
            #else
            return
            #endif
        }
        needsReload = true
        setNeedsLayout()
    }
    
    /// Reload the contents immediately if content reloads are pending.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.reloadDataIfNeeded()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * Use this method to force the view to reload its contents immediately, but If no
    ///       content reloads are pending, this method exits without modifying the contents or
    ///       calling any content-related callbacks.
    ///     * You should call this method on the main thread.
    ///
    @objc dynamic open func reloadDataIfNeeded() {
        guard Thread.isMainThread else {
            #if DEBUG
            fatalError("You should call this method on the main thread.")
            #else
            return
            #endif
        }
        if needsReload {
            reloadData()
        }
    }
    
    /// Reload all contents of the popover view.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.reloadData()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * This method will force the view to reload its contents immediately, even
    ///       without any reload requests.
    ///     * Calling this method will not have any animation, even if some contents are
    ///       changed, like size of container and point of anchor and so on.
    ///     * You should call this method on the main thread.
    ///
    @objc dynamic open func reloadData() {
        p_reloadData()
    }
}

// MARK: - Override

extension FSPopoverView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        reloadDataIfNeeded()
    }
}

// MARK: - Private

private extension FSPopoverView {
    
    /// Invoked after initialization.
    func p_didInitialize() {
        backgroundColor = .cyan
    }
    
    /// Reset all contents to default values.
    func p_resetContents() {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        contentView?.removeFromSuperview()
        contentView = nil
    }
    
    /// Reload all contents and recalculate the position and size of the popover view.
    func p_reloadData() {
        
        guard Thread.isMainThread else {
            #if DEBUG
            fatalError("You should call this method on the main thread.")
            #else
            return
            #endif
        }
        
        needsReload = false
        
        p_resetContents()
        
        
    }
}

// MARK: - Public

public extension FSPopoverView {
    
    #warning("TEST")
    func showTo(_ view: UIView) {
        
        reloadDataIfNeeded()
        
        var frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0)
        frame.origin.x = (displayWindow.bounds.width - frame.width) / 2
        frame.origin.y = {
            guard let superview = view.superview else { return 0.0 }
            let viewFrame = superview.convert(view.frame, to: displayWindow)
            return viewFrame.maxY + 3.0
        }()
        
        displayWindow.addSubview(self)
        displayWindow.isHidden = false
        
        layer.anchorPoint = .init(x: 0.5, y: 0.0)
        self.frame = frame
        transform = .init(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
}

// MARK: - Consts

private struct _Consts {
    static let cornerRadius: CGFloat = 6.0
    static let arrowTopCornerRadius: CGFloat = 3.0
    static let arrowBottomCornerRadius: CGFloat = 4.0
    static let arrowSize = CGSize(width: 28.0, height: 14.0)
    static let minimumSize = CGSize(width: arrowSize.width + cornerRadius * 2 + 10.0,
                                    height: arrowSize.height + 10.0)
}
