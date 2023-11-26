//
//  FSPopoverListTextItem.swift
//  FSPopoverView
//
//  Created by Sheng on 2023/11/23.
//  Copyright © 2023 Sheng. All rights reserved.
//
// > FSPopoverListTextItem looks like：
//   vertical: contents center in vertical
//   NOTE: This mode is compatible with Right-to-Left language.
// ┌────────────────────────────────┬──────────────────────────────────────┐
// │                         <contentInset.top>                            │
// │                                │                                      │
// │-<contentInset.left>-[icon]-<iconSpacing>-[title]-<contentInset.right>-│
// │                                │                                      │
// │                        <contentInset.bottom>                          │
// └────────────────────────────────┴──────────────────────────────────────┘
//   horizontal: contents center in horizontal
// ┌─────────────────────────┬──────────────────────────┐
// │                  <contentInset.top>                │
// │                         │                          │
// │                      [icon]                        │
// │                         │                          │
// │                   <iconSpacing>                    │
// │                         │                          │
// ├ <contentInset.left> -[title]- <contentInset.right> ┤
// │                         │                          │
// │                <contentInset.bottom>               │
// └─────────────────────────┴──────────────────────────┘
//

import UIKit

public final class FSPopoverListTextItem: FSPopoverListItem {
    
    // MARK: Properties/Public
    
    public var contentInset: UIEdgeInsets = .init(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
    
    public var image: UIImage?
    
    public var title: String?
    
    /// The space between image and title.
    /// This value will not work if one of image and title is nil.
    public var spacing: CGFloat = 6.0
    
    /// If nil, use a default font.
    public var titleFont: UIFont?
    
    /// If nil, use a default color.
    public var titleColor: UIColor?
    
    // MARK: Properties/Override
    
    public override var cellType: FSPopoverListCell.Type {
        return FSPopoverListTextCell.self
    }
    
    // MARK: Public
    
    /// You need to call this method if you change any contents.
    public func updateLayout() {
        
        titleFont = titleFont ?? .systemFont(ofSize: 18.0)
        titleColor = titleColor ?? .black
        
        switch scrollDireciton {
        case .vertical:
            p_updateLayoutForVertical()
        case .horizontal:
            p_updateLayoutForHorizontal()
        }
    }
    
    // MARK: Private
    
    private func p_updateLayoutForVertical() {
        var size = CGSize.zero
        let imageSize = image?.size
        let titleSize = p_titleSize()
        size.height = max(imageSize?.height ?? 0, titleSize?.height ?? 0)
        size.height += contentInset.top + contentInset.bottom
        size.width += contentInset.left
        if let width = imageSize?.width {
            size.width += width + spacing
        }
        if let width = titleSize?.width {
            size.width += width
        }
        size.width += contentInset.right
        self.size = size
    }
    
    private func p_updateLayoutForHorizontal() {
        var size = CGSize.zero
        let imageSize = image?.size
        let titleSize = p_titleSize()
        size.width = max(imageSize?.width ?? 0, titleSize?.width ?? 0)
        size.width += contentInset.left + contentInset.right
        size.height += contentInset.top
        if let height = imageSize?.height {
            size.height += height + spacing
        }
        if let height = titleSize?.height {
            size.height += height
        }
        size.height += contentInset.bottom
        self.size = size
    }
    
    private func p_titleSize() -> CGSize? {
        guard let title = title, !title.isEmpty else {
            return nil
        }
        let titleFont = titleFont ?? .systemFont(ofSize: 18.0)
        let attributedTitle = NSAttributedString(string: title, attributes: [.font: titleFont])
        return NSAttributedString.inner.size(of: attributedTitle)
    }
}


// MARK: - FSPopoverListTextCell

private class FSPopoverListTextCell: FSPopoverListCell {
    
    // MARK: Properties/Private
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var stackConstraints = [NSLayoutConstraint]()
    
    // MARK: Override
    
    override func didInitialize() {
        addSubview(stackView)
    }
    
    override func renderContents() {
        super.renderContents()
        guard let item = item as? FSPopoverListTextItem else {
            return
        }
        stackView.axis = item.scrollDireciton == .vertical ? .horizontal : .vertical
        stackView.alpha = item.isEnabled ? 1.0 : 0.5
        stackView.spacing = item.spacing
        do {
            let views = stackView.arrangedSubviews
            views.forEach { $0.removeFromSuperview() }
        }
        if let image = item.image {
            imageView.image = image
            stackView.addArrangedSubview(imageView)
        }
        if let title = item.title, !title.isEmpty {
            titleLabel.text = title
            titleLabel.font = item.titleFont
            titleLabel.textColor = item.titleColor
            stackView.addArrangedSubview(titleLabel)
        }
        p_remakeConstraints()
    }
    
    // MARK: Private
    
    private func p_remakeConstraints() {
        guard let item = item as? FSPopoverListTextItem else {
            return
        }
        NSLayoutConstraint.deactivate(stackConstraints)
        stackConstraints.removeAll()
        switch item.scrollDireciton {
        case .vertical:
            let leading = NSLayoutConstraint(item: stackView,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .leading,
                                             multiplier: 1.0,
                                             constant: item.contentInset.left)
            let trailing = NSLayoutConstraint(item: stackView,
                                              attribute: .trailing,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1.0,
                                              constant: -item.contentInset.right)
            let centerY = NSLayoutConstraint(item: stackView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0.0)
            stackConstraints = [leading, trailing, centerY]
        case .horizontal:
            let top = NSLayoutConstraint(item: stackView,
                                         attribute: .top,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: item.contentInset.top)
            let centerX = NSLayoutConstraint(item: stackView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0.0)
            let centerY = NSLayoutConstraint(item: stackView,
                                             attribute: .centerY,
                                             relatedBy: .lessThanOrEqual,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0.0)
            let width = NSLayoutConstraint(item: stackView,
                                           attribute: .width,
                                           relatedBy: .lessThanOrEqual,
                                           toItem: self,
                                           attribute: .width,
                                           multiplier: 1.0,
                                           constant: 0.0)
            centerY.priority = .defaultHigh
            stackConstraints = [top, centerX, centerY, width]
        }
        addConstraints(stackConstraints)
    }
}
