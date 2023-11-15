//
//  ViewController.swift
//  FSPopoverView
//
//  Created by Sheng on 04/02/2022.
//  Copyright (c) 2022 Sheng. All rights reserved.
//

import UIKit
import FSPopoverView

class ViewController: UIViewController {
    
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
    
    @IBAction func onDidTap(_ sender: Any) {
        
        guard let targetView = sender as? UIView else {
            return
        }
        
        let popoverView = FSPopoverView()
        popoverView.dataSource = self
//        popoverView.borderWidth = 1.0
        popoverView.borderColor = .red
        popoverView.shadowColor = .green
        popoverView.shadowRadius = 3.0
        popoverView.shadowOpacity = 0.6
        popoverView.arrowDirection = .down
//        popoverView.autosetsArrowDirection = false
        popoverView.showsDimBackground = true
        popoverView.show(from: targetView, displayIn: view, animated: true) {
            print("popover view display finished.")
        }
//        popoverView.show(from: view.center, animated: true)
//        popoverView.show(from: .init(x: 100.0, y: 200.0, width: 10.0, height: 10.0), animated: true) {
//            print("popover view display finished.")
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            popoverView.hide(animated: false)
        }
        
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
