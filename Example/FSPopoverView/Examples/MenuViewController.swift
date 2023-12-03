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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
