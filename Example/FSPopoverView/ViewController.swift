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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onDidTap(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let popoverView = FSPopoverView()
        popoverView.showTo(button)
    }
}
