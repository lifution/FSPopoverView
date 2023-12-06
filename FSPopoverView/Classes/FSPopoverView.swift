//
//  FSPopoverView.swift
//  FSPopoverView
//
//  Created by Sheng on 2022/4/2.
//  Copyright © 2023 Sheng. All rights reserved.
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
    /// * A reload request will be set when this property is set.
    ///
    weak open var dataSource: FSPopoverViewDataSource? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// The transitioning delegate object is a custom object that you provide
    /// and that conforms to the FSPopoverViewAnimatedTransitioning protocol.
    ///
    /// * You can use this property to custom the transition animation of popover view.
    /// * A default transitioning delegate is set for popover view.
    /// * This object is not retained.
    ///
    weak open var transitioningDelegate: FSPopoverViewAnimatedTransitioning? {
        didSet {
            if let scale = scaleTransition, scale !== transitioningDelegate {
                scaleTransition = nil
            }
        }
    }
    
    /// The direction of the popover's arrow.
    ///
    /// * You can change this property even though the popover view is displaying.
    /// * A reload request will be set when this property is changed.
    /// * See `autosetsArrowDirection` property for more information about this
    ///   property.
    ///
    open var arrowDirection = FSPopoverView.ArrowDirection.up {
        didSet {
            if arrowDirection != oldValue, !autosetsArrowDirection, !isReloading {
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
    /// * A reload request will be set when this property is changed.
    ///
    /// - Important
    ///     * When this property is true, the popover view will calculate the appropriate
    ///       position based on the size of it's container and the position of the arrow.
    ///       So, when you set this property to false, you should ensure that there is enough
    ///       space in the container for the popover view to appear, otherwise the popover
    ///       view may be in the wrong place.
    ///
    open var autosetsArrowDirection = true {
        didSet {
            if autosetsArrowDirection != oldValue {
                setNeedsReload()
            }
        }
    }
    
    // MARK: Properties/Public
    
    /// The location of the arrow's vertex.
    /// Defaults to (0, 0).
    ///
    /// * This point is in the coordinate system of `containerView`.
    /// * This point will be recalculated on reload operation.
    /// * The value of `showsArrow` has no effect on this property.
    ///
    final public private(set) var arrowPoint: CGPoint = .zero
    
    /// The container view displaying the popover view.
    /// This view will be created when the popover view needs to be displayed.
    ///
    /// If popover view is displaying in a specified view, the specified view will be the superview
    /// of the container view. Otherwise, a window will be created automatically inside the popover
    /// view as the superview of the container view, and this window will be the same size as the
    /// current screen.
    ///
    /// The popover view is added to the container view.
    /// The view hierarchy is:
    /// ```
    /// specified view / window
    ///   - container view (same size as specified view / window)
    ///     - dim background view (same size as container view)
    ///     - user interaction view (same size as container view)
    ///     - popover view
    ///       - popover container view
    ///         - background view
    ///         - content view (from data source)
    /// ```
    ///
    final weak public private(set) var containerView: UIView?
    
    /// Arrow will be hidden when this property is set to false.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var showsArrow: Bool {
        didSet {
            if showsArrow != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// Whether needs to show a dim background on container view.
    /// Default value see `FSPopoverViewAppearance`.
    final public var showsDimBackground: Bool {
        didSet {
            dimBackgroundView.isHidden = !showsDimBackground
        }
    }
    
    /// The corner radius of the popover view.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is set.
    ///
    final public var cornerRadius: CGFloat {
        didSet {
            if cornerRadius != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The size of the arrow.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is set.
    ///
    final public var arrowSize: CGSize {
        didSet {
            if arrowSize != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The width of the popover view border.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var borderWidth: CGFloat {
        didSet {
            if borderWidth != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The color of the popover view border.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is set.
    ///
    final public var borderColor: UIColor? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// The color of the popover view shadow.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is set.
    ///
    final public var shadowColor: UIColor? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// The radius of the popover view shadow.
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is changed.
    ///
    final public var shadowRadius: CGFloat {
        didSet {
            if shadowRadius != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The opacity of the popover view shadow.
    /// The value in this property must be in the range 0.0 (transparent) to 1.0 (opaque).
    /// Default value see `FSPopoverViewAppearance`.
    ///
    /// * A reload request will be set when this property is changed.
    /// 
    final public var shadowOpacity: Float {
        didSet {
            if shadowOpacity != oldValue {
                setNeedsReload()
            }
        }
    }
    
    // MARK: Properties/Override
    
    /// It's objected to use this property to set the background color of popover view.
    /// Use `backgroundView` of `dataSource` instead.
    @available(*, unavailable)
    final public override var backgroundColor: UIColor? {
        get { return nil }
        set {}
    }
    
    // MARK: Properties/Private
    
    private var needsReload = false
    
    private var isFreezing = false
    
    private var isReloading = false
    
    private let delegateRouter = FSPopoverViewDelegateRouter()
    
    weak private var backgroundView: UIView?
    
    weak private var contentView: UIView?
    
    /// `backgroundView` and `contentView` will be added to this view.
    ///
    /// * This view will be the same size as the popover view.
    ///
    private lazy var popoverContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    weak private var borderLayer: CALayer?
    weak private var shadowLayer: CALayer?
    
    /// Size of `containerView`.
    private var containerSize: CGSize = .zero
    
    /// This rect is in the coordinate system of `containerView`.
    private var arrowReferRect: CGRect = .zero
    
    /// If there is no specified view to display popover view,
    /// this window will be created.
    private var displayWindow: UIWindow?
    
    /// The dim background on container view.
    private lazy var dimBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .init(white: 0.0, alpha: 0.25)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    /// The view that receives user interaction.
    private lazy var userInteractionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        do {
            let tap = UITapGestureRecognizer(target: self, action: #selector(p_handleTap))
            tap.delegate = delegateRouter
            view.addGestureRecognizer(tap)
        }
        return view
    }()
    
    /// The default value of transitioning delegate.
    private var scaleTransition: FSPopoverViewTransitionScale?
    
    // MARK: Initialization
    
    public init() {
        do {
            // appearance
            let appearance = FSPopoverViewAppearance.shared
            showsArrow = appearance.showsArrow
            showsDimBackground = appearance.showsDimBackground
            cornerRadius = appearance.cornerRadius
            arrowSize = appearance.arrowSize
            borderWidth = appearance.borderWidth
            borderColor = appearance.borderColor
            shadowColor = appearance.shadowColor
            shadowRadius = appearance.shadowRadius
            shadowOpacity = appearance.shadowOpacity
        }
        super.init(frame: .zero)
        p_didInitialize()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods/Override
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        reloadDataIfNeeded()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17, *) {} else {
            setNeedsReload()
        }
    }
    
    @available(*, unavailable)
    open override class func appearance() -> Self {
        return super.appearance()
    }
    
    @available(*, unavailable)
    open override class func appearance(for trait: UITraitCollection) -> Self {
        return super.appearance(for: trait)
    }
    
    @available(*, unavailable)
    open override class func appearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type]) -> Self {
        return super.appearance(whenContainedInInstancesOf: containerTypes)
    }
    
    @available(*, unavailable)
    open override class func appearance(for trait: UITraitCollection, whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type]) -> Self {
        return super.appearance(for: trait, whenContainedInInstancesOf: containerTypes)
    }
    
    // MARK: Methods/Open
    
    /// Tells the popover view to reload all of its contents.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.setNeedsReload()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * This method makes a note of the request and returns immediately. This method
    ///       does not force an immediate reload, all of the contents will reload in view's
    ///       next layout update cycle. This behavior allows you to consolidate all of your
    ///       content reloads to one layout update cycle, which is usually better for performance.
    ///     * You should call this method on the main thread.
    ///
    open func setNeedsReload() {
        p_mainThreadCheck()
        needsReload = true
        setNeedsLayout()
    }
    
    /// Reload the contents immediately if the reload operation is pending.
    ///
    /// - Requires
    ///     * Subclasses **must** call `super.reloadDataIfNeeded()` when overriding this method,
    ///       otherwise some bugs may occur.
    ///
    /// - Note
    ///     * Use this method to force the popover view to reload its contents immediately, but if
    ///       the reload operation is not pending, this method exits without modifying the contents
    ///       or calling any content-related callbacks.
    ///     * You should call this method on the main thread.
    ///
    open func reloadDataIfNeeded() {
        p_mainThreadCheck()
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
    ///       changed, like size of content and direction of arrow and so on.
    ///     * You should call this method on the main thread.
    ///
    open func reloadData() {
        p_mainThreadCheck()
        isReloading = true
        p_reloadData()
        isReloading = false
    }
    
    /// Get the transition context for the specified scene.
    open func transitionContext(for scene: FSPopoverViewTransitionContext.Scene) -> FSPopoverViewTransitionContext {
        return FSPopoverViewTransitionContext(scene: scene, popoverView: self, dimBackgroundView: dimBackgroundView)
    }
    
    /// Presents the popover and anchors it to the specified view.
    open func present(fromView view: UIView,
                      displayIn specifiedView: UIView? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        p_present(from: view.frame,
                  in: view.superview,
                  displayIn: specifiedView,
                  animated: animated,
                  completion: completion)
    }
    
    /// Presents the popover and anchors it to the specified location.
    /// - Parameters:
    ///   - view: The view containing the point.
    open func present(fromPoint point: CGPoint,
                      in view: UIView? = nil,
                      displayIn specifiedView: UIView? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        p_present(from: .init(origin: point, size: .zero),
                  in: view,
                  displayIn: specifiedView,
                  animated: animated,
                  completion: completion)
    }
    
    /// Presents the popover and anchors it to the specified rect.
    /// - Parameters:
    ///   - view: The view containing the rectangle.
    open func present(fromRect rect: CGRect,
                      in view: UIView? = nil,
                      displayIn specifiedView: UIView? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        p_present(from: rect,
                  in: view,
                  displayIn: specifiedView,
                  animated: animated,
                  completion: completion)
    }
    
    /// Presents the popover and anchors it to the specified bar item.
    open func present(fromBarItem barItem: UIBarItem, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let view = barItem.value(forKey: "view") as? UIView else {
            #if DEBUG
            fatalError("The value of UIBarItem has been changed, this method can not be used anymore.")
            #else
            return
            #endif
        }
        p_present(from: view.frame,
                  in: view.superview,
                  animated: animated,
                  completion: completion)
    }
    
    /// Dismiss popover view.
    open func dismiss(animated: Bool = true, isSelection: Bool = false, completion: (() -> Void)? = nil) {
        p_dismiss(animated: animated, isSelection: isSelection, completion: completion)
    }
}

// MARK: - Methods/Private

private extension FSPopoverView {
    
    /// Invoked after initialization.
    func p_didInitialize() {
        
        popoverContainerView.backgroundColor = .clear
        
        delegateRouter.gestureRecognizerShouldBeginHandler = { [unowned self] gestureRecognizer in
            if let view = gestureRecognizer.view, view === self.userInteractionView {
                if self.isFreezing {
                    return true
                }
                let location = gestureRecognizer.location(in: view)
                return !self.frame.contains(location)
            }
            return false
        }
        
        if #available(iOS 17, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.setNeedsReload()
            }
        }
        
        addSubview(popoverContainerView)
        popoverContainerView.inner.makeMarginConstraints(to: self)
        
        scaleTransition = FSPopoverViewTransitionScale()
        transitioningDelegate = scaleTransition
    }
    
    func p_mainThreadCheck() {
        #if DEBUG
        if !Thread.isMainThread {
            fatalError("You must call this method on the main thread.")
        }
        #endif
    }
    
    func p_getArrowSize() -> CGSize {
        guard showsArrow else {
            return .zero
        }
        var size = arrowSize
        size.width = max(size.width, 0)
        size.height = max(size.height, 0)
        return size
    }
    
    func p_createContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func p_createDisplayWindow() -> UIWindow {
        let window = UIWindow()
        window.windowLevel = .statusBar - 1
        window.backgroundColor = .clear
        return window
    }
    
    func p_prepareForDisplaying() {
        // freezes the popover view before the popover view finishes displaying operation.
        isFreezing = true
        alpha = 1.0
        transform = .identity
        removeFromSuperview()
        containerSize = .zero
        containerView?.removeFromSuperview()
        dimBackgroundView.alpha = 1.0
        dimBackgroundView.transform = .identity
        p_destroyDisplayWindow()
    }
    
    func p_setContainerView(_ view: UIView) {
        
        containerView = view
        
        dimBackgroundView.removeFromSuperview()
        view.addSubview(dimBackgroundView)
        dimBackgroundView.inner.makeMarginConstraints(to: view)
        
        userInteractionView.removeFromSuperview()
        view.addSubview(userInteractionView)
        userInteractionView.inner.makeMarginConstraints(to: view)
    }
    
    func p_destroyDisplayWindow() {
        displayWindow?.isHidden = true
        displayWindow?.subviews.forEach { $0.removeFromSuperview() }
        displayWindow = nil
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
        
        p_mainThreadCheck()
        
        needsReload = false
        
        // clear old contents
        p_resetContents()
        
        guard containerSize.width > 0, containerSize.height > 0 else {
            return
        }
        
        // container safe area insets
        let safeAreaInsets = dataSource?.containerSafeAreaInsets(for: self) ?? .zero
        let safeContainerRect = CGRect(origin: .zero, size: containerSize).inset(by: safeAreaInsets)
        
        // content size
        let realContentSize = dataSource?.contentSize(for: self) ?? .zero
        let contentSize: CGSize
        
        // arrow size
        let arrowSize = p_getArrowSize()
        
        // arrow direction
        do {
            let horizontalContentSize: CGSize = {
                var size = CGSize(width: cornerRadius * 2 + 10.0, height: arrowSize.height + cornerRadius * 2 + 10.0)
                if realContentSize.width > size.width {
                    size.width = realContentSize.width
                }
                if realContentSize.height > size.height {
                    size.height = realContentSize.height
                }
                return size
            }()
            let verticalContentSize: CGSize = {
                var size = CGSize(width: arrowSize.width + cornerRadius * 2 + 10.0, height: cornerRadius * 2 + 10.0)
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
        // This point is in the coordinate system of container view.
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
                var rect = safeContainerRect.insetBy(dx: cornerRadius, dy: cornerRadius)
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
            view.inner.makeMarginConstraints(to: popoverContainerView)
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
        
        // draw popover view
        do {
            let arrowPointInPopover = CGPoint(x: arrowPoint.x - frame.minX, y: arrowPoint.y - frame.minY)
            
            var context = FSPopoverDrawContext()
            context.showsArrow      = showsArrow
            context.arrowSize       = arrowSize
            context.arrowPoint      = arrowPointInPopover
            context.arrowDirection  = arrowDirection
            context.cornerRadius    = cornerRadius
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
    
    func p_present(from rect: CGRect,
                   in view: UIView? = nil,
                   displayIn specifiedView: UIView? = nil,
                   animated: Bool = true,
                   completion: (() -> Void)? = nil) {
        
        p_mainThreadCheck()
        p_prepareForDisplaying()
        
        let displayView: UIView = {
            /// NOTE:
            ///   When displaying in the UIScrollView, container view can not get the correct size.
            ///   So ignore scroll view here.
            if let view = specifiedView, !(view is UIScrollView), view.bounds.width > 0, view.bounds.height > 0.0 {
                return view
            }
            let window = p_createDisplayWindow()
            window.bounds = .init(origin: .zero, size: UIScreen.main.bounds.size)
            window.isHidden = false
            displayWindow = window
            return window
        }()
        
        arrowReferRect = {
            if let view = view {
                return view.convert(rect, to: displayView)
            }
            return rect
        }()
        
        let containerView = p_createContainerView()
        do {
            p_setContainerView(containerView)
            displayView.addSubview(containerView)
            containerView.inner.makeMarginConstraints(to: displayView)
            displayView.layoutIfNeeded()
        }
        
        containerSize = containerView.bounds.size
        
        setNeedsReload()
        
        // This operation will cause the method `layoutSubviews()` to be called, and then
        // the method `reloadDataIfNeeded()` will be called, so it's unnecessary to call
        // `reloadDataIfNeeded()` explicitly here.
        containerView.addSubview(self)
        // Layout the popover view for the animation of the next step.
        containerView.layoutIfNeeded()
        
        let completedHandler: (() -> Void) = { [unowned self] in
            self.isFreezing = false
            completion?()
        }
        
        if animated, let transitioning = transitioningDelegate {
            let context = transitionContext(for: .present)
            context.onDidCompleteTransition = completedHandler
            transitioning.animateTransition(transitionContext: context)
        } else {
            completedHandler()
        }
    }
    
    func p_dismiss(animated: Bool = true, isSelection: Bool = false, completion: (() -> Void)? = nil) {
        
        p_mainThreadCheck()
        
        // Can not do anything when the popover view begins disappearing.
        isFreezing = true
        
        containerView?.isUserInteractionEnabled = false
        
        let completedHandler: (() -> Void) = { [unowned self] in
            self.isFreezing = false
            self.removeFromSuperview()
            self.containerView?.removeFromSuperview()
            self.p_destroyDisplayWindow()
            completion?()
        }
        
        if animated, let transitioning = transitioningDelegate {
            let context = transitionContext(for: .dismiss(isSelection))
            context.onDidCompleteTransition = completedHandler
            transitioning.animateTransition(transitionContext: context)
        } else {
            completedHandler()
        }
    }
}

// MARK: - Methods/Actions

private extension FSPopoverView {
    
    @objc func p_handleTap() {
        guard
            !isFreezing, // Can not do anything while the popover view is freezing.
            dataSource?.popoverViewShouldDismissOnTapOutside(self) ?? true
        else {
            return
        }
        p_dismiss()
    }
}

// MARK: - Methods/Public

public extension FSPopoverView {
    
    /// Call this method if you want to bring the popover view to the front of
    /// the view displaying the popover view.
    func moveToFront() {
        guard
            let containerView = containerView,
            let superview = containerView.superview
        else {
            return
        }
        superview.bringSubviewToFront(containerView)
    }
    
    /// Call this method to get the maximum size in the direction.
    ///
    /// Sometimes, the size of your content view may need to be adjusted to fit the popover view.
    /// Such as your content view is a table view with a lot of cells, and the popover view doesn't
    /// have enough space for the table view to show all of the cells, this requires the data source
    /// object to return a proper content size. In this time, you need a size as a reference, and
    /// this is where this method in handy.
    ///
    /// - Important:
    ///   * Return nil if the popover view is not yet ready for presenting, so it's recommended that
    ///     call this method in the content size method of data source object.
    ///
    func maximumContentSizeOf(direction: FSPopoverView.ArrowDirection) -> CGSize? {
        
        guard containerSize.width > 0, containerSize.height > 0 else {
            return nil
        }
        
        let arrowSize = p_getArrowSize()
        let referRect = arrowReferRect.insetBy(dx: -arrowSize.height, dy: -arrowSize.height)
        let safeAreaInsets = dataSource?.containerSafeAreaInsets(for: self) ?? .zero
        let safeContainerRect = CGRect(origin: .zero, size: containerSize).inset(by: safeAreaInsets)
        
        switch direction {
        case .up:
            return CGSize(width: safeContainerRect.width, height: max(0.0, safeContainerRect.maxY - referRect.maxY))
        case .down:
            return CGSize(width: safeContainerRect.width, height: max(0.0, referRect.minY - safeContainerRect.minY))
        case .left:
            return CGSize(width: max(0.0, safeContainerRect.maxX - referRect.maxX), height: safeContainerRect.height)
        case .right:
            return CGSize(width: max(0.0, referRect.minX - safeContainerRect.minX), height: safeContainerRect.height)
        }
    }
}
