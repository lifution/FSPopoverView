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
        guard let button = sender as? UIButton else { return }
        let popoverView = FSPopoverView()
        popoverView.dataSource = self
//        popoverView.borderWidth = 1.0
        popoverView.borderColor = .red
        popoverView.shadowColor = .green
        popoverView.shadowRadius = 3.0
        popoverView.shadowOpacity = 0.6
//        popoverView.arrowDirection = .right
//        popoverView.autosetsArrowDirection = false
        popoverView.showsDimBackground = true
        popoverView.showTo(button)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            popoverView.arrowDirection = .left
////            popoverView.isArrowEnabled = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                popoverView.arrowDirection = .down
////                popoverView.isArrowEnabled = true
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
        insets.left = 15.0
        insets.right = 15.0
        return insets
    }
}
