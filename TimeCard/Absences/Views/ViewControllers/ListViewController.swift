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
    var list = [String]()
    var sendData : (()->())?
       override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Absences"
        self.customNavigationType = .navWithBack
        self.setupTableViewConfigur()
       }
    func setupTableViewConfigur(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        cell.valueLabel.isHidden = true
        cell.arrowImageView.isHidden = true
        cell.contentLbl.text = list[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendData?()
         self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

}
