////
////  NewRecordViewController.swift
////  TimeCard
////
////  Created by Naveen Kumar K N on 31/12/19.
////  Copyright © 2019 Naveen Kumar K N. All rights reserved.
////
//
//import UIKit
//
//class NewRecordViewController: BaseViewController {
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = newRecordingScreenTitile
//        self.customNavigationType = .navWithSaveandCancel
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.configurTableView()
//    }
//    
//    override func selectedCancel(sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    func configurTableView(){
//        tableView.delegate = self
//        tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "AbsencesTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "AbsencesTableViewCell")
//        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
//    }
//}
//
//extension NewRecordViewController:UITableViewDataSource,UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 3
//        default:
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AbsencesTableViewCell" ) as! AbsencesTableViewCell
//                headerView.contentLbl.text = "Allocated Hours"
//                      return headerView
//        default:
//             let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AbsencesTableViewCell" ) as! AbsencesTableViewCell
//             headerView.contentLbl.text = "Absences"
//             headerView.addBtn.isHidden = true
//            return headerView
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//             let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
//             switch indexPath.row {
//             case 0:
//                cell.contentLbl.text = "Time Type"
//                cell.cellTextField.text = "Working Time"
//             case 1:
//                cell.contentLbl.text = "Duration"
//                cell.valueLabel.text = "0 Hours"
//                cell.valueLabel.textColor = Color.theme.value
//             default:
//                cell.contentLbl.text = "Cost centre"
//                cell.valueLabel.text = "Select"
//             }
//            return cell
//        default:
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
//            cell.valueLabel.isHidden = true
//            cell.contentLbl.text = "Add Absences"
//             return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return UITableView.automaticDimension
//        default:
//            return 40
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            break
//        default:
//            if indexPath.row == 0{
//                
//            }
//            break
//        }
//    }
//}
