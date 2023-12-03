//
//  ListViewController.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/3.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class ListViewController: UIViewController {
    
    private let listView = FSPopoverListView()
    
    private var patterns = [FSPopoverListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let titles = ["Design", "Factory", "Singleton", "Builder", "Strategy", "Abstract Factory"]
            patterns = titles.map { title in
                let item = SelectableItem()
                item.title = title
                item.isSeparatorHidden = false
                item.selectedHandler = { item in
                    if let item = item as? SelectableItem {
                        item.isSelected = !item.isSelected
                        item.reload(.rerender)
                    }
                }
                item.updateLayout()
                return item
            }
            patterns.last?.isSeparatorHidden = true
        }
    }
    
    @IBAction func customListItem(_ sender: UIBarButtonItem) {
        listView.items = patterns
        listView.dismissWhenSelected = false
        listView.present(fromBarItem: sender)
    }
    
    @IBAction func present(_ sender: UIButton) {
        let features: [Feature] = [.copy, .message, .db, .qr, .settings]
        let items: [FSPopoverListItem] = features.map { feature in
            let item = FSPopoverListTextItem()
            item.image = feature.image
            item.title = feature.title
            item.isSeparatorHidden = false
            item.selectedHandler = { item in
                guard let item = item as? FSPopoverListTextItem else {
                    return
                }
                print(item.title ?? "")
            }
            item.updateLayout()
            return item
        }
        items.last?.isSeparatorHidden = true
        listView.items = items
        listView.dismissWhenSelected = true
        listView.present(fromRect: sender.frame.insetBy(dx: 0.0, dy: -6.0), in: view)
    }
}

// MARK: - Custom List Item

private class SelectableItem: FSPopoverListItem {
    
    // MARK: Properties/Fileprivate
    
    fileprivate var title: String?
    
    fileprivate var isSelected = false
    
    // MARK: Properties/Override
    
    override var cellType: FSPopoverListCell.Type {
        return SelectableCell.self
    }
    
    // MARK: Initialization
    
    init() {
        super.init(scrollDirection: .vertical)
        selectionStyle = .none
        separatorInset = SelectableCell.Consts.contentInset
    }
    
    // MARK: Fileprivate
    
    /// You need to call this method if you change any contents.
    fileprivate func updateLayout() {
        var size = CGSize.zero
        let imageSize = CGSize(width: 20.0, height: 20.0)
        let titleSize = p_titleSize()
        let contentInset = SelectableCell.Consts.contentInset
        let spacing = FSPopoverView.fs_appearance().spacing
        size.height = max(imageSize.height, titleSize?.height ?? 0)
        size.height += contentInset.top + contentInset.bottom
        size.width += contentInset.left
        size.width += imageSize.width
        if let width = titleSize?.width {
            size.width += spacing
            size.width += width
        }
        size.width += contentInset.right
        self.size = size
    }
    
    private func p_titleSize() -> CGSize? {
        guard let title = title, !title.isEmpty else {
            return nil
        }
        let titleFont = FSPopoverView.fs_appearance().textFont
        let att_string = NSAttributedString(string: title, attributes: [.font: titleFont])
        let size = att_string.boundingRect(with: .init(width: 1000.0, height: 1000.0),
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           context: nil).size
        return .init(width: ceil(size.width), height: ceil(size.height))
    }
}

private class SelectableCell: FSPopoverListCell {
    
    // MARK: Consts
    
    fileprivate struct Consts {
        static let contentInset = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    }
    
    // MARK: Properties/Private
    
    private let iconButton = UIButton()
    private let textLabel = UILabel()
    
    // MARK: Override
    
    override func didInitialize() {
        super.didInitialize()
        
        iconButton.isUserInteractionEnabled = false
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        iconButton.setImage(.init(named: "unselected"), for: .normal)
        iconButton.setImage(.init(named: "selected"), for: .selected)
        
        textLabel.font = FSPopoverView.fs_appearance().textFont
        textLabel.textColor = FSPopoverView.fs_appearance().textColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconButton)
        addSubview(textLabel)
        
        let inset = Self.Consts.contentInset
        let spacing = FSPopoverView.fs_appearance().spacing
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[icon]-spacing-[text]",
                                                      metrics: ["left": inset.left, "spacing": spacing],
                                                      views: ["icon": iconButton, "text": textLabel]))
        addConstraint(NSLayoutConstraint(item: iconButton,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0))
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0.0))
    }
    
    override func renderContents() {
        super.renderContents()
        guard let item = item as? SelectableItem else {
            return
        }
        textLabel.text = item.title
        iconButton.isSelected = item.isSelected
    }
}
