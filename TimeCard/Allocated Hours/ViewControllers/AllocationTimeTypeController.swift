//
//  AllocationTimeTypeController.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import UIKit
protocol UpdateData:class {
    func updateValue(value:String?)
}
class AllocationTimeTypeController: BaseViewController {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewConstant: NSLayoutConstraint!
    
    var timeType:[AvailableTimeData]?
    var allocationData:AllocationModel?
    weak var delegate:UpdateData?
    var cellType: AllocationCellIdentifier?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        self.tableViewConstant.constant = 0
        self.timeType = self.timeType?.filter({$0.timeTypeNav?.timeType?.category == "ATTENDANCE"})
    }
}
extension AllocationTimeTypeController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeType?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell  = UITableViewCell(style:.default, reuseIdentifier: "Cell")
        let timeTypeData = timeType?[indexPath.row]
        cell.textLabel?.text = timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? ""
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeTypeData = timeType?[indexPath.row]
        guard let type = cellType else { return }
        switch type {
        case .timeType:
            delegate?.updateValue(value:timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? "")
            self.navigationController?.popViewController(animated: true)
            return
        case .costCenter:
            delegate?.updateValue(value:timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? "")
            self.navigationController?.popViewController(animated: true)
            return
        default: return
        }
       
    }
}
