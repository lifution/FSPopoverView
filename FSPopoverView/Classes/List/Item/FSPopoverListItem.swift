//
//  FSPopoverListItem.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// Abstract base class, cannot be used directly, must be inherited for use.
open class FSPopoverListItem {
    
    public enum ReloadType {
        /// Only update contents of the cell binding with the
        /// current item, no update in size and other cells.
        case rerender
        /// Reload the whole contents of FSPopoverListView.
        case reload
    }
    
    // MARK: Properties/Open
    
    /// The size of item.
    ///
    /// - The cell's frame.size may not equal to this size.
    ///
    /// - When the scroll direction of FSPopoverListView is `vertical`,
    ///   the list view picks out the largest `size.width` from its items as its width.
    ///
    /// - When the scroll direction of FSPopoverListView is `horizontal`,
    ///   the list view picks out the largest `size.height` from its items as its height.
    ///
    open var size: CGSize = .zero
    
    /// Type of the cell that binding with the item.
    ///
    /// - This type must be the subclass of FSPopoverListCell.
    ///
    open var cellType: FSPopoverListCell.Type {
        return FSPopoverListCell.self
    }
    
    // MARK: Properties/Public
    
    public let scrollDireciton: FSPopoverListView.ScrollDirection
    
    public final var separatorInset: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    /// The color of separator. Defaults to nil.
    public final var separatorColor: UIColor?
    
    /// Whether needs hide separator, defaults to true.
    ///
    /// - The separator is on the bottom when scroll direction is vertical.
    /// - The separator is on the right when scroll direction is horizontal.
    ///
    public final var isSeparatorHidden = true
    
    // MARK: Properties/Internal
    
    /// Use for reload operation.
    ///
    /// - Warning:
    ///   * ⚠️ Leave this closure alone, you should never use it.
    ///
    final var reloadHandler: ((FSPopoverListItem, FSPopoverListItem.ReloadType) -> Void)?
    
    // MARK: Initialization
    
    public init(scrollDireciton: FSPopoverListView.ScrollDirection = .vertical) {
        #if DEBUG
        let abstractName = String(describing: FSPopoverListItem.self)
        if "\(type(of: self))" == abstractName {
            fatalError("\(abstractName) is abstract base class, cannot be used directly, must be inherited for use.")
        }
        #endif
        self.scrollDireciton = scrollDireciton
    }
    
    // MARK: Public
    
    /// Reqests a reload operation for current item.
    /// This method will not work if the cell has not been added to list view.
    public final func reload(_ type: FSPopoverListItem.ReloadType = .rerender) {
        reloadHandler?(self, type)
    }
}
