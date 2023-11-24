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
    
    /// The background view's background color.
    /// Defaults to white.
    public final var backgroundColor: UIColor? {
        get { return backgroundView.backgroundColor }
        set { backgroundView.backgroundColor = newValue }
    }
    
    // MARK: Properties/Private
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let backgroundView = UIView()
    
    private var contentSize = CGSize.zero
    
    private var cells = [FSPopoverListCell]()
    
    // MARK: Initialization
    
    public init(scrollDirection: FSPopoverListView.ScrollDirection = .vertical) {
        self.scrollDirection = scrollDirection
        super.init(frame: .zero)
        p_didInitialize()
    }
    
    // MARK: FSPopoverViewDataSource
    
    open func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        return backgroundView
    }
    
    open func contentView(for popoverView: FSPopoverView) -> UIView? {
        return scrollView
    }
    
    open func contentSize(for popoverView: FSPopoverView) -> CGSize {
        if let items = items {
            var contentSize = CGSize.zero
            switch scrollDirection {
            case .vertical:
                contentSize.width = items.map { $0.size.width }.max() ?? 0
                contentSize.height = items.map { $0.size.height }.reduce(0, +)
            case .horizontal:
                contentSize.width = items.map { $0.size.width }.reduce(0, +)
                contentSize.height = items.map { $0.size.height }.max() ?? 0
            }
            self.contentSize = contentSize
        } else {
            contentSize = .zero
        }
        return contentSize
    }
    
    open func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        return .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    open func popoverViewShouldDismissOnTapOutside(_ popoverView: FSPopoverView) -> Bool {
        return shouldDismissOnTapOutside
    }
    
    // MARK: Override
    
    open override func reloadData() {
        
//        cells.forEach { $0.removeFromSuperview() }
//        cells.removeAll()
        
//        let items = items ?? []
//        var contentSize = CGSize.zero
//        
//        switch scrollDirection {
//        case .vertical:
//            contentSize.width = items.map { $0.size.width }.max() ?? 0
//            contentSize.height = items.map { $0.size.height }.reduce(0, +)
//        case .horizontal:
//            contentSize.width = items.map { $0.size.width }.reduce(0, +)
//            contentSize.height = items.map { $0.size.height }.max() ?? 0
//        }
//        
//        self.contentSize = contentSize
        
        super.reloadData()
        
        scrollView.contentSize = contentSize
        
        let items = items ?? []
        
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        
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
            cells.append(cell)
            lastCell = cell
            item.reloadHandler = { [weak cell, weak self] _, type in
                if type == .reload {
                    self?.setNeedsReload()
                } else {
                    cell?.renderContents()
                }
            }
        }
    }
}

// MARK: - Private

private extension FSPopoverListView {
    
    /// Invoked after initialization.
    func p_didInitialize() {
        dataSource = self
        backgroundView.backgroundColor = .white
    }
}
