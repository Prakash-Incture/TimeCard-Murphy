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
    
    
    var timeType:AllocationCellIdentifier?
    var allocationData:AllocationModel?
    weak var delegate:UpdateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationType = .navWithBack
        // Do any additional setup after loading the view.
        
    }
}
extension AllocationTimeTypeController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeType?.inputViewForSelection.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell  = UITableViewCell(style:.default, reuseIdentifier: "Cell")
         cell.textLabel?.text = timeType?.inputViewForSelection[indexPath.row] ?? ""
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.allocationData?.timeType = timeType?.inputViewForSelection[indexPath.row] ?? ""
        delegate?.updateValue(value: self.allocationData?.timeType ?? "")
        self.navigationController?.popViewController(animated: true)
        return
    }
}
