//
//  allocatedTimeTableCell.swift
//  TimeCard
//
//  Created by prakash on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class AllocatedTimeTableCell: UITableViewCell {
    @IBOutlet weak var tableView: UITableView!

    var HeaderCell = AllocationHeader.getAllocationCells()
    var parent:UIViewController?
    var allocationDataArray:[AllocationModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    var currentPage:CurrentPage?
    var allocationViewModel:AllocationDataViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "GenericTableviewDropdownCell", bundle: nil), forCellReuseIdentifier: "GenericTableviewDropdownCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension AllocatedTimeTableCell:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.allocationDataArray?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeaderCell.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.HeaderCell[indexPath.row]
        switch cellModel.reuseIdentifier {
        case .GenericTableviewDropdownCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            cell.setModel(cellModel)
            cell.selectionStyle = .none
            cell.parent = parent
            cell.allocationViewModel = self.allocationViewModel
            cell.allocationData = self.allocationDataArray?[indexPath.section]
            return cell
        case .AllocatedTimeTableCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            return cell
        case .WeekSummaryCell:
             guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
                return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let _: CGRect = tableView.frame
            let headerView = (Bundle.main.loadNibNamed("Headercell", owner: self, options: nil)?[0] as? Headercell)
            headerView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
            headerView?.addButtom.addTarget(self, action: #selector(allocatedHoursAction), for: .touchUpInside)
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
       }
    @objc func allocatedHoursAction(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addAllocatedDataToArray"), object:self.allocationDataArray)
        return
    }
}
