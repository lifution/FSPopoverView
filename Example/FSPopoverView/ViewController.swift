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
        label.font = .systemFont(ofSize: 150.0)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onDidTap(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let popoverView = FSPopoverView()
        popoverView.dataSource = self
        popoverView.showTo(button)
    }
}

extension ViewController: FSPopoverViewDataSource {
    
    func backgroundView(for popoverView: FSPopoverView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return ghostView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return ghostView.sizeThatFits(.init(width: 100.0, height: 100.0))
    }
}
