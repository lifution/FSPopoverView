//
//  FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/2.
//  Copyright (c) 2022 Sheng. All rights reserved.
//

import UIKit

open class FSPopoverView: UIView {
    
    // MARK: ArrowDirection
    
    public enum ArrowDirection {
        case up, down, left, right
    }
    
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
    
    /// The direction the arrow points to.
    ///
    /// * You can change this property even though the popover view is displaying.
    /// * A reload request will be set when this property is changed.
    /// * View `autosetsArrowDirection` property for more information about this
    ///   property.
    ///
    open var arrowDirection = FSPopoverView.ArrowDirection.up {
        didSet {
            if arrowDirection != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// Whether to set the arrow direction automatically.
    /// Default is true.
    ///
    /// * When this property is true, the popover view will determine the direction
    ///   of the arrow and update the `arrowDirection` property automatically.
    /// * When this property is false, The popover view will calculate it's position
    ///   according to the `arrowDirection` property, and the `arrowDirection` property
    ///   will never be changed by inside.
    ///
    /// - Important
    ///     - When this property is true, the popover view will calculate the appropriate
    ///       position based on the size of it's container and the position of the arrow.
    ///       So, when you set this property to false, you should ensure that there is enough
    ///       space in the container for the popover view to appear, otherwise the popover
    ///       view may be in the wrong place.
    ///
    open var autosetsArrowDirection = true
    
    // MARK: Properties/Public
    
    /// The point the arrow points to.
    /// Default is (0, 0).
    ///
    /// * This point is in the coordinate system of `containerView`. (same as the popover view)
    /// * This point will be recalculated on every reload operation.
    ///
    public private(set) var arrowPoint: CGPoint = .zero
    
    /// The container view in which the popover view is displayed.
    ///
    /// * If there is no specified container view, a window will be automatically created
    ///   inside the popover view as a container view, and this window will be the same
    ///   size as the current screen.
    ///
    weak public private(set) var containerView: UIView?
    
    // MARK: Properties/Private
    
    private var needsReload = false
    
    private var backgroundView: UIView?
    
    private var contentView: UIView?
    
    /// Size of `containerView`.
    private var containerSize: CGSize = .zero
    
    /// This rect is in the coordinate system of `containerView`.
    private var arrowReferRect: CGRect = .zero
    
    private lazy var displayWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = .statusBar - 1
        window.backgroundColor = .clear
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
    
    /// Reload the contents immediately, even without any reload requests.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.reloadData()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * Calling this method will not have any animation, even if some contents are
    ///       changed, like size of content and point of anchor and so on.
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
        backgroundColor = .clear
    }
    
    /// Reset all contents to default values.
    func p_resetContents() {
        contentView?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        contentView = nil
        backgroundView = nil
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
        
        // clear old contents
        p_resetContents()
        
        // content size
        let contentSize = dataSource?.contentSize(for: self) ?? .zero
        
        // container safe area insets
        let safeAreaInsets = dataSource?.containerSafeAreaInsets(for: self) ?? .zero
        let safeContainerRect = CGRect(origin: .zero, size: containerSize).inset(by: safeAreaInsets)
        
        // arrow direction
        if autosetsArrowDirection {
            let referRect = arrowReferRect.insetBy(dx: -_Consts.arrowSize.height, dy: -_Consts.arrowSize.height)
            let topSpace    = CGSize(width: safeContainerRect.width, height: max(0.0, referRect.minY - safeContainerRect.minY))
            let leftSpace   = CGSize(width: max(0.0, referRect.minX - safeContainerRect.minX), height: safeContainerRect.height)
            let bottomSpace = CGSize(width: safeContainerRect.width, height: max(0.0, safeContainerRect.maxY - referRect.maxY))
            let rightSpace  = CGSize(width: max(0.0, safeContainerRect.maxX - referRect.maxX), height: safeContainerRect.height)
            // priority: up > down > left > right
            if bottomSpace.width >= contentSize.width && bottomSpace.height >= contentSize.height {
                arrowDirection = .up
            } else if topSpace.width >= contentSize.width && topSpace.height >= contentSize.height {
                arrowDirection = .down
            } else if rightSpace.width >= contentSize.width && rightSpace.height >= contentSize.height {
                arrowDirection = .left
            } else if leftSpace.width >= contentSize.width && leftSpace.height >= contentSize.height {
                arrowDirection = .right
            } else {
                // `up` will be set if there is not enough space to show popover view.
                arrowDirection = .up
                #if DEBUG
                let message = """
                ⚠️ Not enough space to show popover view, \
                you may need to check if the popover view is showing on the wrong view. ⚠️
                """
                print(message)
                #endif
            }
        }
        
        // arrow point
        do {
            var point = CGPoint.zero
            switch arrowDirection {
            case .up:
                point.x = arrowReferRect.midX
                point.y = arrowReferRect.maxY
            case .down:
                point.x = arrowReferRect.midX
                point.y = arrowReferRect.minY
            case .left:
                point.x = arrowReferRect.maxX
                point.y = arrowReferRect.midY
            case .right:
                point.x = arrowReferRect.minX
                point.y = arrowReferRect.midY
            }
            // If the point is on the edge, a little adjustment is required for improving the visual effect.
            let arrowPointSafeRect: CGRect = {
                var rect = safeContainerRect.insetBy(dx: _Consts.cornerRadius, dy: _Consts.cornerRadius)
                rect = rect.insetBy(dx: 3.0, dy: 3.0)
                rect = rect.insetBy(dx: _Consts.arrowSize.width / 2, dy: _Consts.arrowSize.width / 2)
                return rect
            }()
            if !arrowPointSafeRect.contains(point) {
                switch arrowDirection {
                case .up, .down:
                    if point.x < arrowPointSafeRect.minX {
                        point.x = arrowPointSafeRect.minX
                    }
                    if point.x > arrowPointSafeRect.maxX {
                        point.x = arrowPointSafeRect.maxX
                    }
                case .left, .right:
                    if point.y < arrowPointSafeRect.minY {
                        point.y = arrowPointSafeRect.minY
                    }
                    if point.y > arrowPointSafeRect.maxY {
                        point.y = arrowPointSafeRect.maxY
                    }
                }
            }
            arrowPoint = point
        }
        
        // frame of the popover view
        let frame: CGRect = {
            let size: CGSize = {
                var width: CGFloat = contentSize.width, height: CGFloat = contentSize.height
                switch arrowDirection {
                case .up, .down:
                    height += _Consts.arrowSize.height
                case .left, .right:
                    width += _Consts.arrowSize.height
                }
                width = max(width, _Consts.minimumSize.width)
                height = max(height, _Consts.minimumSize.height)
                return .init(width: width, height: height)
            }()
            var origin = CGPoint.zero
            switch arrowDirection {
            case .up, .down:
                origin.x = {
                    var x = arrowPoint.x - size.width / 2
                    x = max(safeContainerRect.minX, min(safeContainerRect.maxX, x))
                    return x
                }()
            case .left, .right:
                origin.y = {
                    var y = arrowPoint.y - size.height / 2
                    y = max(safeContainerRect.minY, min(safeContainerRect.maxY, y))
                    return y
                }()
            }
            switch arrowDirection {
            case .up:
                origin.y = arrowPoint.y
            case .down:
                origin.y = arrowPoint.y - size.height
            case .left:
                origin.x = arrowPoint.x
            case .right:
                origin.x = arrowPoint.x - size.width
            }
            return .init(origin: origin, size: size)
        }()
        self.frame = frame
        
        // background view
        if let view = dataSource?.backgroundView(for: self) {
            addSubview(view)
            backgroundView = view
            view.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", metrics: nil, views: ["view": view]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: ["view": view]))
        }
        
        // content view
        if let view = dataSource?.contentView(for: self) {
            contentView = view
            addSubview(view)
            var frame = CGRect.zero
            frame.size = contentSize
            switch arrowDirection {
            case .up:
                frame.origin.y =  _Consts.arrowSize.height
            case .left:
                frame.origin.x =  _Consts.arrowSize.height
            case .down, .right:
                frame.origin = .zero
            }
            view.frame = frame
        }
        
        // anchor point
        layer.anchorPoint = {
            var x: CGFloat = 0.0, y: CGFloat = 0.0
            let anchorPoint: CGPoint = {
                guard let containerView = containerView else { return .zero }
                var point = containerView.convert(arrowPoint, to: self)
                point.x = max(0.0, min(frame.width, point.x))
                point.y = max(0.0, min(frame.height, point.y))
                return point
            }()
            switch arrowDirection {
            case .up:
                x = anchorPoint.x / frame.width
            case .down:
                x = anchorPoint.x / frame.width
                y = 1.0
            case .left:
                y = anchorPoint.y / frame.height
            case .right:
                x = 1.0
                y = anchorPoint.y / frame.height
            }
            return .init(x: x, y: y)
        }()
        
        // Needs to reset frame again after updating layer.anchorPoint,
        // or the popover view will be in the wrong place.
        self.frame = frame
        
        // popover view bezier path
        if let containerView = containerView {
            
            let arrowPointInPopover = containerView.convert(arrowPoint, to: self)
            let context = FSPopoverDrawContext(arrowSize: _Consts.arrowSize,
                                               arrowPoint: arrowPointInPopover,
                                               cornerRadius: _Consts.cornerRadius,
                                               contentSize: contentSize,
                                               popoverSize: frame.size)
            let drawer: FSPopoverDrawer = {
                switch arrowDirection {
                case .up:
                    return FSPopoverDrawUp()
                case .down:
                    return FSPopoverDrawDown()
                case .left:
                    return FSPopoverDrawLeft()
                case .right:
                    return FSPopoverDrawRight()
                }
            }()
            let maskPath = drawer.draw(with: context)
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
            
        } else {
            
        }
    }
}

// MARK: - Public

public extension FSPopoverView {
    
    #warning("TEST")
    func showTo(_ view: UIView) {
        
        containerView = displayWindow
        containerSize = UIScreen.main.bounds.size
        displayWindow.bounds = .init(origin: .zero, size: containerSize)
        arrowReferRect = {
            guard let superview = view.superview else { return .zero }
            return superview.convert(view.frame, to: displayWindow)
        }()
        
        reloadDataIfNeeded()
        
        displayWindow.addSubview(self)
        displayWindow.isHidden = false
        
        transform = .init(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.18, delay: 0.0, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
}

// MARK: - Consts

private struct _Consts {
    static let cornerRadius: CGFloat = 6.0
    static let arrowSize = CGSize(width: 30.0, height: 14.0)
    static let minimumSize = CGSize(width: arrowSize.width + cornerRadius * 2 + 10.0,
                                    height: arrowSize.height + 10.0)
}
