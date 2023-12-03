//
//  MenuViewController.swift
//  FSPopoverView_Example
//
//  Created by Sheng on 2023/12/3.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class MenuViewController: UITableViewController {
    
    private let menuView = FSPopoverListView(scrollDirection: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let features: [Feature] = [.forward, .delete, .quote, .translate]
            let items: [FSPopoverListItem] = features.map { feature in
                let item = FSPopoverListTextItem(scrollDirection: .horizontal)
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
            menuView.items = items
        }
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began, let label = sender.view else { return }
        menuView.present(fromView: label)
    }
}

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
