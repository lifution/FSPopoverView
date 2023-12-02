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
    
    public let scrollDirection: FSPopoverListView.ScrollDirection
    
    /// A closure to execute when the user selects the item.
    /// This closure has no return value and takes the selected item object as its only parameter.
    public final var selectedHandler: ((_ item: FSPopoverListItem) -> Void)?
    
    /// Whether the item is enabled. Defaults to true.
    public final var isEnabled = true
    
    /// Default value see `FSPopoverViewAppearance`.
    public final var separatorInset: UIEdgeInsets = FSPopoverViewAppearance.shared.separatorInset
    
    /// The color of separator.
    /// Default value see `FSPopoverViewAppearance`.
    public final var separatorColor: UIColor? = FSPopoverViewAppearance.shared.separatorColor
    
    /// Whether needs hide separator, defaults to true.
    ///
    /// - The separator is on the bottom when scroll direction is vertical.
    /// - The separator is on the right when scroll direction is horizontal.
    ///
    public final var isSeparatorHidden = true
    
    /// The color of separator.
    /// Default value see `FSPopoverViewAppearance`.
    public final var highlightedColor: UIColor? = FSPopoverViewAppearance.shared.highlightedColor
    
    // MARK: Properties/Internal
    
    /// Use for reload operation.
    ///
    /// - Warning:
    ///   * ⚠️ Leave this closure alone, you should never use it.
    ///
    final var reloadHandler: ((FSPopoverListItem, FSPopoverListItem.ReloadType) -> Void)?
    
    // MARK: Initialization
    
    public init(scrollDirection: FSPopoverListView.ScrollDirection = .vertical) {
        #if DEBUG
        let abstractName = String(describing: FSPopoverListItem.self)
        if "\(type(of: self))" == abstractName {
            fatalError("\(abstractName) is abstract base class, cannot be used directly, must be inherited for use.")
        }
        #endif
        self.scrollDirection = scrollDirection
    }
    
    // MARK: Public
    
    /// Reqests a reload operation for current item.
    /// This method will not work if the cell has not been added to list view.
    public final func reload(_ type: FSPopoverListItem.ReloadType = .rerender) {
        reloadHandler?(self, type)
    }
}
