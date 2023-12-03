//
//  ViewController.swift
//  FSPopoverView
//
//  Created by Sheng on 04/02/2022.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
