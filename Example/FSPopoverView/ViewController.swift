//
//  ViewController.swift
//  FSPopoverView
//
//  Created by Sheng on 04/02/2022.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class ViewController: UITableViewController {
    
    private let customTransition = FSPopoverViewTransitionTranslate()
    
    private lazy var ghostView: UIView = {
        let label = UILabel()
        label.text = "👻"
        label.font = .systemFont(ofSize: 120.0)
        label.textAlignment = .center
//        label.backgroundColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onDidTap(_ sender: Any) {
        
        guard let targetView = sender as? UIView else {
            return
        }
        
//        let popoverView = FSPopoverView()
        let popoverView = FSPopoverListView(scrollDirection: .vertical)
//        popoverView.dataSource = self
//        popoverView.borderWidth = 1.0
        popoverView.borderColor = .red
        popoverView.shadowColor = .green
        popoverView.shadowRadius = 3.0
        popoverView.shadowOpacity = 0.6
//        popoverView.showsArrow = false
        popoverView.arrowDirection = .right
//        popoverView.autosetsArrowDirection = false
        popoverView.showsDimBackground = true
//        popoverView.transitioningDelegate = customTransition
//        popoverView.maximumCountOfVisibleItems = 3
        
        popoverView.items = ["扫一扫", "添加好友", "加入群聊"].compactMap({ text in
            let item = FSPopoverListTextItem(scrollDireciton: popoverView.scrollDirection)
            item.title = text
            item.image = .init(named: "qr_light")
            item.separatorColor = .red
            item.isSeparatorHidden = false
            item.updateLayout()
            item.selectedHandler = { [weak item] i in
                print("选中了：[\(item?.title ?? "")]")
            }
//            if #available(iOS 13.0, *) {
//                item.separatorColor = UIColor(dynamicProvider: { trait in
//                    return trait.userInterfaceStyle == .dark ? .cyan : .red
//                })
//            } else {
//                item.separatorColor = .red
//            }
            return item
        })
        (popoverView.items?.last as? FSPopoverListTextItem)?.isSeparatorHidden = true
        (popoverView.items?.last as? FSPopoverListTextItem)?.isEnabled = false
        
//        popoverView.present(from: targetView, displayIn: view, animated: true) {
//            print("popover view present finished.")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                if let item = popoverView.items?.last as? FSPopoverListTextItem {
//                    item.isSeparatorHidden = false
//                    item.reload()
//                }
//            }
//        }
//        popoverView.present(from: view.center, animated: true)
//        popoverView.present(from: .init(x: 100.0, y: 200.0, width: 10.0, height: 10.0), animated: true) {
//            print("popover view display finished.")
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            popoverView.dismiss(animated: true) {
//                print("popover view dismiss finished.")
//            }
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            popoverView.arrowDirection = .left
////            popoverView.showsArrow = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                popoverView.arrowDirection = .down
////                popoverView.showsArrow = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    popoverView.arrowDirection = .up
//                }
//            }
//        }
    }
}

extension ViewController: FSPopoverViewDataSource {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return ghostView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return ghostView.sizeThatFits(.init(width: 1000.0, height: 1000.0))
    }
    
    func containerSafeAreaInsets(for popoverView: FSPopoverView) -> UIEdgeInsets {
        var insets = view.safeAreaInsets
        insets.left = 10.0
        insets.right = 10.0
        return insets
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
