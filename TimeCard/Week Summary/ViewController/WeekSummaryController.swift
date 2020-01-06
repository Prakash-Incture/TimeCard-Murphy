//
//  WeekSummaryController.swift
//  TimeCard
//
//  Created by prakash on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class WeekSummaryController: UIViewController {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigation()
    }
    func setUpNavigation(){
        self.tableView.tableFooterView = UIView()
        let filterItem = UIBarButtonItem.init(title:"Action", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onTapofAction))
        navigationItem.rightBarButtonItem = filterItem
        self.navigationItem.title = "Week Summary"
    }
}
// MARK: - Table view data source
extension WeekSummaryController:UITableViewDelegate,UITableViewDataSource{
   func numberOfSections(in tableView: UITableView) -> Int {
       return 2
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 0
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
       return cell
   }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if section == 0{
               let _: CGRect = tableView.frame
               let headerView = (Bundle.main.loadNibNamed("Headercell", owner: self, options: nil)?[1] as? WeekHaderCell)
               headerView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
               return headerView
           }
           return nil
       }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }
        return 30
    }
 }
extension WeekSummaryController{
    @objc func onTapofAction() {
          
       }
}
