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
    weak var delegate:UpdateData?
    var absenseData:[AvailableTimeData]?

       override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Absences"
        //self.customNavigationType = .navPlain
        self.absenseData = self.absenseData?.filter({$0.timeTypeNav?.timeType?.category == "ABSENCE"})
        self.setupTableViewConfigur()
       }
    func setupTableViewConfigur(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
    }
   
}

extension ListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.absenseData?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let data = self.absenseData?[indexPath.row]
        cell.contentLbl.text = data?.timeTypeNav?.timeType?.externalName_en_US
        cell.cellTextField.isHidden = true
        cell.accessoryType = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.sendData?()
        let data = self.absenseData?[indexPath.row]
         self.delegate?.updateValue(value:data?.timeTypeNav?.timeType?.externalName_en_US)
         self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}
