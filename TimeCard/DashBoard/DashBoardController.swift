//
//  DashBoardController.swift
//  TimeCard
//
//  Created by prakash on 07/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class DashBoardController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dashBoardArray:[String] = ["    TIME SHEET","    APPROVALS"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpTableView()
    }

    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
          self.tableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashBoardCell")

    }

}
extension DashBoardController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashBoardArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = self.tableView.dequeueReusableCell(withIdentifier: "DashBoardCell", for: indexPath) as! DashBoardCell
        cell.dashBoardLabel.text = self.dashBoardArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newRecordVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            //  let navController = UINavigationController(rootViewController : newRecordVC)
            DataSingleton.shared.totalHours = "0"
            self.navigationController?.pushViewController(newRecordVC, animated: true)
        default:
            let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
            let newRecordVC = storyBoard.instantiateViewController(withIdentifier: "ApprovalListController") as! ApprovalListController
            self.navigationController?.pushViewController(newRecordVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
