//
//  FSPopoverListView.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

open class FSPopoverListView: FSPopoverView, FSPopoverViewDataSource {
    
    // MARK: ScrollDirection
    
    public enum ScrollDirection {
        case vertical
        case horizontal
    }
    
    // MARK: Properties/Open
    
    /// The scroll direction of the list.
    open var scrollDirection: FSPopoverListView.ScrollDirection {
        didSet {
            if scrollDirection != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// The list items.
    /// An item represents a cell.
    open var items: [FSPopoverListItem]? {
        didSet {
            setNeedsReload()
        }
    }
    
    /// Whether needs to dismiss list view when user tap the blank area.
    /// Defaults to true.
    open var shouldDismissOnTapOutside = true
    
    // MARK: Properties/Public
    
    /// Limits the number of visible items displayed in the list view.
    /// It means there is no limit if this value less than or equal to 0.
    /// Defaults to 0.
    public final var maximumCountOfVisibleItems = 0 {
        didSet {
            if maximumCountOfVisibleItems != oldValue {
                setNeedsReload()
            }
        }
    }
    
    /// Auto dismiss the list view when an item is selected.
    /// Defaults to true.
    public final var dismissWhenSelected = true
    
    /// The background view's background color.
    /// Defaults to white.
    public final var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }
    
    // MARK: Properties/Private
    
    private let scrollView = _ListScrollView()
    
    private let backgroundView = UIView()
    
    private var contentSize = CGSize.zero
    
    private var scrollContentSize = CGSize.zero
    
    // MARK: Initialization
    
    public init(scrollDirection: FSPopoverListView.ScrollDirection = .vertical) {
        self.scrollDirection = scrollDirection
        super.init()
        p_didInitialize()
    }
    
    // MARK: Override
    
    open override func reloadData() {
        
        super.reloadData()
        
        scrollView.contentSize = scrollContentSize
        
        let items = items ?? []
        
        scrollView.cells.forEach { $0.removeFromSuperview() }
        scrollView.cells.removeAll()
        
        var lastCell: FSPopoverListCell?
        items.forEach { item in
            let cell = item.cellType.init(item: item)
            do {
                var frame = lastCell?.frame ?? .zero
                switch scrollDirection {
                case .vertical:
                    frame.origin.y = frame.maxY
                    frame.size.width = contentSize.width
                    frame.size.height = item.size.height
                case .horizontal:
                    frame.origin.x = frame.maxX
                    frame.size.width = item.size.width
                    frame.size.height = contentSize.height
                }
                cell.frame = frame
            }
            cell.renderContents()
            scrollView.addSubview(cell)
            scrollView.cells.append(cell)
            lastCell = cell
            item.reloadHandler = { [unowned cell, unowned self] _, type in
                if type == .reload {
                    self.setNeedsReload()
                } else {
                    cell.renderContents()
                }
            }
        }
    }
    
    // MARK: Open/FSPopoverViewDataSource
    
    open func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        return backgroundView
    }
    
    open func contentView(for popoverView: FSPopoverView) -> UIView? {
        return scrollView
    }
    
    open func contentSize(for popoverView: FSPopoverView) -> CGSize {
        guard
            let upMaxSize = maximumContentSizeOf(direction: .up),
            let downMaxSize = maximumContentSizeOf(direction: .down),
            let leftMaxSize = maximumContentSizeOf(direction: .left),
            let rightMaxSize = maximumContentSizeOf(direction: .right)
        else {
            return .zero
        }
        if let items = items {
            var contentSize = CGSize.zero
            do {
                // original content size.
                switch scrollDirection {
                case .vertical:
                    contentSize.width = items.map { $0.size.width }.max() ?? 0
                    contentSize.height = items.map { $0.size.height }.reduce(0, +)
                case .horizontal:
                    contentSize.width = items.map { $0.size.width }.reduce(0, +)
                    contentSize.height = items.map { $0.size.height }.max() ?? 0
                }
                scrollContentSize = contentSize
            }
            do {
                // limits maximum content size.
                let maxSize: CGSize
                if autosetsArrowDirection {
                    // priority: up > down > left > right
                    if upMaxSize.width >= contentSize.width && upMaxSize.height >= contentSize.height {
                        maxSize = upMaxSize
                    } else if downMaxSize.width >= contentSize.width && downMaxSize.height >= contentSize.height {
                        maxSize = downMaxSize
                    } else if leftMaxSize.width >= contentSize.width && leftMaxSize.height >= contentSize.height {
                        maxSize = leftMaxSize
                    } else if rightMaxSize.width >= contentSize.width && rightMaxSize.height >= contentSize.height {
                        maxSize = rightMaxSize
                    } else {
                        // Use up maximum size if there is no compatible size.
                        maxSize = upMaxSize
                    }
                } else {
                    switch arrowDirection {
                    case .up:
                        maxSize = upMaxSize
                    case .down:
                        maxSize = downMaxSize
                    case .left:
                        maxSize = leftMaxSize
                    case .right:
                        maxSize = rightMaxSize
                    }
                }
                contentSize.width = min(contentSize.width, maxSize.width)
                contentSize.height = min(contentSize.height, maxSize.height)
            }
            do {
                // limits maximum count of visible items.
                if maximumCountOfVisibleItems > 0, maximumCountOfVisibleItems < items.count {
                    let visibleItems = items[0..<maximumCountOfVisibleItems]
                    let lastVisibleItem = items[maximumCountOfVisibleItems]
                    var limitedSize = contentSize
                    switch scrollDirection {
                    case .vertical:
                        limitedSize.height = visibleItems.map { $0.size.height }.reduce(0, +)
                        limitedSize.height += floor(lastVisibleItem.size.height / 2)
                        contentSize.height = min(contentSize.height, limitedSize.height)
                    case .horizontal:
                        limitedSize.width = visibleItems.map { $0.size.width }.reduce(0, +)
                        limitedSize.width += floor(lastVisibleItem.size.width / 2)
                        contentSize.width = min(contentSize.width, limitedSize.width)
                    }
                }
            }
            self.contentSize = contentSize
        } else {
            contentSize = .zero
        }
        return contentSize
    }
    
    open func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        var insets = containerView?.safeAreaInsets ?? .zero
        if insets.top <= 0 { insets.top = 10.0 }
        if insets.bottom <= 0 { insets.bottom = 10.0 }
        if insets.left <= 0 { insets.left = 10.0 }
        if insets.right <= 0 { insets.right = 10.0 }
        return insets
    }
    
    open func popoverViewShouldDismissOnTapOutside(_ popoverView: FSPopoverView) -> Bool {
        return shouldDismissOnTapOutside
    }
    
    // MARK: Open
    
    open func didSelectItem(_ item: FSPopoverListItem) {
        let operation: () -> Void = {
            item.selectedHandler?(item)
        }
        if dismissWhenSelected {
            dismiss(animated: true, isSelection: true) {
                operation()
            }
        } else {
            operation()
        }
    }
}

// MARK: - Private

private extension FSPopoverListView {
    
    /// Invoked after initialization.
    func p_didInitialize() {
        dataSource = self
        backgroundView.backgroundColor = FSPopoverView.fs_appearance().backgroundColor
        scrollView.selectedCellHandler = { [unowned self] cell in
            self.didSelectItem(cell.item)
        }
    }
}


// MARK: - _ListScrollView

private class _ListScrollView: UIScrollView {
    
    // MARK: Properties/Fileprivate
    
    var cells = [FSPopoverListCell]()
    
    var selectedCellHandler: ((_ cell: FSPopoverListCell) -> Void)?
    
    // MARK: Properties/Private
    
    private var highlightedCell: FSPopoverListCell?
    
    // MARK: Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightedCell?.isHighlighted = false
        highlightedCell = nil
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let cell = p_cell(at: location), cell.item.isEnabled {
            cell.isHighlighted = true
            highlightedCell = cell
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let cell = highlightedCell {
            if cell.frame.contains(location) {
                if !cell.isHighlighted {
                    cell.isHighlighted = true
                }
            } else {
                if cell.isHighlighted {
                    cell.isHighlighted = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let cell = p_cell(at: location) {
            if let highlightedCell = highlightedCell, highlightedCell === cell {
                selectedCellHandler?(highlightedCell)
            }
        }
        highlightedCell = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightedCell?.isHighlighted = false
        highlightedCell = nil
    }
    
    // MARK: Private
    
    private func p_cell(at location: CGPoint) -> FSPopoverListCell? {
        guard !cells.isEmpty else { return nil }
        var result: FSPopoverListCell? = nil
        for cell in cells {
            if cell.frame.contains(location) {
                result = cell
                break
            }
        }
        return result
    }
}
