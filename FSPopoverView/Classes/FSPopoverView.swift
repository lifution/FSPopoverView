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
    /// Defaults to true.
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
    
    /// Arrow will be hidden when this property is set to false.
    /// Defaults to true.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var isArrowEnabled = true {
        didSet {
            if isArrowEnabled != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The vertex of the arrow.
    /// Defaults to (0, 0).
    ///
    /// * This point is in the coordinate system of `containerView`. (same as the popover view)
    /// * This point will be recalculated on reload operation.
    /// * The value of `isArrowEnabled` has no effect on this property.
    ///
    final public private(set) var arrowPoint: CGPoint = .zero
    
    /// The container view in which the popover view is displayed.
    ///
    /// * If there is no specified container view, a window will be automatically created
    ///   inside the popover view as a container view, and this window will be the same
    ///   size as the current screen.
    ///
    final weak public private(set) var containerView: UIView?
    
    /// The color of the popover view border.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var borderColor: UIColor? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// The width of the popover view border.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The color of the popover view shadow.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var shadowColor: UIColor? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// The radius of the popover view shadow.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var shadowRadius: CGFloat = 0.0 {
        didSet {
            if shadowRadius != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The opacity of the popover view shadow.
    /// The value in this property must be in the range 0.0 (transparent) to 1.0 (opaque).
    /// Defaults to 1.0.
    ///
    /// * A reload request will be set when this property is changed.
    /// 
    final public var shadowOpacity: Float = 1.0 {
        didSet {
            if shadowOpacity != oldValue {
                setNeedsReload()
            }
        }
    }
    
    // MARK: Properties/Override
    
    /// It's objected to use this property to set the background color of popover view.
    /// Use `backgroundView` of `dataSource` instead.
    final public override var backgroundColor: UIColor? {
        get { return popoverContainerView.backgroundColor }
        set {
            super.backgroundColor = .clear
            popoverContainerView.backgroundColor = newValue
        }
    }
    
    // MARK: Properties/Private
    
    private var needsReload = false
    
    weak private var backgroundView: UIView?
    
    weak private var contentView: UIView?
    
    /// `backgroundView` and `contentView` will be added to this view.
    ///
    /// * This view will be the same size as the popover view.
    ///
    private lazy var popoverContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak private var borderLayer: CALayer?
    weak private var shadowLayer: CALayer?
    
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
        
        addSubview(popoverContainerView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      metrics: nil,
                                                      views: ["view": popoverContainerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      metrics: nil,
                                                      views: ["view": popoverContainerView]))
    }
    
    /// Reset all contents to default values.
    func p_resetContents() {
        borderLayer?.removeFromSuperlayer()
        shadowLayer?.removeFromSuperlayer()
        contentView?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        borderLayer = nil
        shadowLayer = nil
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
        
        // container safe area insets
        let safeAreaInsets = dataSource?.containerSafeAreaInsets(for: self) ?? .zero
        let safeContainerRect = CGRect(origin: .zero, size: containerSize).inset(by: safeAreaInsets)
        
        // content size
        let realContentSize = dataSource?.contentSize(for: self) ?? .zero
        let contentSize: CGSize
        
        // arrow size
        let arrowSize = isArrowEnabled ? _Consts.arrowSize : .zero
        
        // arrow direction
        do {
            let horizontalContentSize: CGSize = {
                var size = CGSize(width: _Consts.cornerRadius * 2 + 20.0,
                                  height: arrowSize.width + _Consts.cornerRadius * 2 + 20.0)
                if realContentSize.width > size.width {
                    size.width = realContentSize.width
                }
                if realContentSize.height > size.height {
                    size.height = realContentSize.height
                }
                return size
            }()
            let verticalContentSize: CGSize = {
                var size = CGSize(width: arrowSize.width + _Consts.cornerRadius * 2 + 20.0,
                                  height: _Consts.cornerRadius * 2 + 20.0)
                if realContentSize.width > size.width {
                    size.width = realContentSize.width
                }
                if realContentSize.height > size.height {
                    size.height = realContentSize.height
                }
                return size
            }()
            if autosetsArrowDirection {
                let referRect   = arrowReferRect.insetBy(dx: -arrowSize.height, dy: -arrowSize.height)
                let topSpace    = CGSize(width: safeContainerRect.width, height: max(0.0, referRect.minY - safeContainerRect.minY))
                let leftSpace   = CGSize(width: max(0.0, referRect.minX - safeContainerRect.minX), height: safeContainerRect.height)
                let bottomSpace = CGSize(width: safeContainerRect.width, height: max(0.0, safeContainerRect.maxY - referRect.maxY))
                let rightSpace  = CGSize(width: max(0.0, safeContainerRect.maxX - referRect.maxX), height: safeContainerRect.height)
                // priority: up > down > left > right
                if bottomSpace.width >= verticalContentSize.width && bottomSpace.height >= verticalContentSize.height {
                    contentSize = verticalContentSize
                    arrowDirection = .up
                } else if topSpace.width >= verticalContentSize.width && topSpace.height >= verticalContentSize.height {
                    contentSize = verticalContentSize
                    arrowDirection = .down
                } else if rightSpace.width >= horizontalContentSize.width && rightSpace.height >= horizontalContentSize.height {
                    contentSize = horizontalContentSize
                    arrowDirection = .left
                } else if leftSpace.width >= horizontalContentSize.width && leftSpace.height >= horizontalContentSize.height {
                    contentSize = horizontalContentSize
                    arrowDirection = .right
                } else {
                    // `up` will be set if there is not enough space to show popover view.
                    arrowDirection = .up
                    contentSize = verticalContentSize
                    #if DEBUG
                    let message = """
                    ⚠️ Not enough space to show popover view, \
                    you may need to check if the popover view is showing on the wrong view. ⚠️
                    """
                    print(message)
                    #endif
                }
            } else {
                switch arrowDirection {
                case .up, .down:
                    contentSize = verticalContentSize
                case .left, .right:
                    contentSize = horizontalContentSize
                }
            }
        }
        
        // arrow point
        // arrow point is in the coordinate system of container view.
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
                rect = rect.insetBy(dx: arrowSize.width / 2, dy: arrowSize.width / 2)
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
        
        // The frame of the popover view in the container view.
        let frame: CGRect = {
            let size: CGSize = {
                var width: CGFloat = contentSize.width, height: CGFloat = contentSize.height
                switch arrowDirection {
                case .up, .down:
                    height += arrowSize.height
                case .left, .right:
                    width += arrowSize.height
                }
                return .init(width: width, height: height)
            }()
            var origin = CGPoint.zero
            switch arrowDirection {
            case .up, .down:
                origin.x = {
                    var x = arrowPoint.x - size.width / 2
                    if arrowPoint.x <= safeContainerRect.midX {
                        x = max(x, safeContainerRect.minX)
                    }
                    if arrowPoint.x > safeContainerRect.midX {
                        x = min(x, safeContainerRect.maxX - size.width)
                    }
                    return x
                }()
            case .left, .right:
                origin.y = {
                    var y = arrowPoint.y - size.height / 2
                    if arrowPoint.y <= safeContainerRect.midY {
                        y = max(y, safeContainerRect.minY)
                    }
                    if arrowPoint.y > safeContainerRect.midY {
                        y = min(y, safeContainerRect.maxY - size.height)
                    }
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
            popoverContainerView.addSubview(view)
            backgroundView = view
            view.translatesAutoresizingMaskIntoConstraints = false
            popoverContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                               metrics: nil,
                                                                               views: ["view": view]))
            popoverContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                               metrics: nil,
                                                                               views: ["view": view]))
        }
        
        // content view
        if let view = dataSource?.contentView(for: self) {
            popoverContainerView.addSubview(view)
            contentView = view
            var frame = CGRect.zero
            frame.size = realContentSize
            switch arrowDirection {
            case .up:
                frame.origin.x = (contentSize.width - realContentSize.width) / 2
                frame.origin.y = arrowSize.height + (contentSize.height - realContentSize.height) / 2
            case .left:
                frame.origin.x =  arrowSize.height + (contentSize.width - realContentSize.width) / 2
                frame.origin.y = (contentSize.height - realContentSize.height) / 2
            case .down, .right:
                frame.origin.x = (contentSize.width - realContentSize.width) / 2
                frame.origin.y = (contentSize.height - realContentSize.height) / 2
            }
            view.frame = frame
        }
        
        // anchor point
        do {
            defer {
                // Needs to reset frame again after updating layer.anchorPoint,
                // or the popover view will be in the wrong place.
                self.frame = frame
            }
            layer.anchorPoint = {
                var x: CGFloat = 0.0, y: CGFloat = 0.0
                let arrowPointInPopover = CGPoint(x: arrowPoint.x - frame.minX,
                                                  y: arrowPoint.y - frame.minY)
                switch arrowDirection {
                case .up:
                    x = arrowPointInPopover.x / frame.width
                case .down:
                    x = arrowPointInPopover.x / frame.width
                    y = 1.0
                case .left:
                    y = arrowPointInPopover.y / frame.height
                case .right:
                    x = 1.0
                    y = arrowPointInPopover.y / frame.height
                }
                return .init(x: x, y: y)
            }()
        }
        
        // draw popover view
        do {
            let arrowPointInPopover = CGPoint(x: arrowPoint.x - frame.minX,
                                              y: arrowPoint.y - frame.minY)
            
            var context = FSPopoverDrawContext()
            context.isArrowEnabled  = isArrowEnabled
            context.arrowSize       = arrowSize
            context.arrowPoint      = arrowPointInPopover
            context.arrowDirection  = arrowDirection
            context.cornerRadius    = _Consts.cornerRadius
            context.contentSize     = contentSize
            context.popoverSize     = frame.size
            context.borderWidth     = borderWidth
            context.borderColor     = borderColor
            context.shadowColor     = shadowColor
            context.shadowRadius    = shadowRadius
            context.shadowOpacity   = shadowOpacity
            
            let drawer = FSPopoverDrawer(context: context)
            
            // mask
            do {
                let path = drawer.generatePath()
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                popoverContainerView.layer.mask = maskLayer
            }
            
            // shadow
            if let image = drawer.generateShadowImage() {
                let layer = CALayer()
                layer.contents = image.cgImage
                self.layer.addSublayer(layer)
                self.shadowLayer = layer
                layer.frame.size = image.size
                layer.frame.origin.x = (frame.width - image.size.width) / 2
                layer.frame.origin.y = (frame.height - image.size.height) / 2
            }
            
            // border
            if let image = drawer.generateBorderImage() {
                let layer = CALayer()
                layer.contents = image.cgImage
                self.layer.addSublayer(layer)
                self.borderLayer = layer
                layer.frame.size = image.size
                layer.frame.origin.x = (frame.width - image.size.width) / 2
                layer.frame.origin.y = (frame.height - image.size.height) / 2
            }
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
    static let arrowSize = CGSize(width: 20.0, height: 10.0)
}
