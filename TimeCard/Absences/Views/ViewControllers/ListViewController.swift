//
//  ListViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
              
       override func viewDidLoad() {
           super.viewDidLoad()
           self.customNavigationType = .navWithBack

       }
    
}

