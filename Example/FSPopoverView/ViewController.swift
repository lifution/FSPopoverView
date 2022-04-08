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
    
    private lazy var smileView: UIImageView = {
        return UIImageView(image: .init(named: "smile"))
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
        return nil
    }
    
    func contentView(for popoverView: FSPopoverView) -> UIView? {
        return smileView
    }
    
    func contentSize(for popoverView: FSPopoverView) -> CGSize {
        return smileView.image?.size ?? .zero
    }
}
