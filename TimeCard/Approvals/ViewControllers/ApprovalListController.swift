//
//  ApprovalListController.swift
//  TimeCard
//
//  Created by prakash on 07/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class ApprovalListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    func initialSetup() {
        
        self.tableView.register(UINib(nibName: "ApprovalListCell", bundle: nil), forCellReuseIdentifier: "ApprovalListCell")
        approveBtn.layer.cornerRadius = 5.0
    }
    
    @IBAction func selectAllBtnTapped(_ sender: Any) {
        selectAllBtn.isSelected = !selectAllBtn.isSelected
        tableView.reloadData()
    }
    
    @IBAction func approveBtnTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
        if let timeSheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetDetailsVC") as? TimesheetDetailsVC{
            self.navigationController?.pushViewController(timeSheetVC, animated: true)
        }
    }
    
}

extension ApprovalListController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 335.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalListCell") as? ApprovalListCell{
            
            cell.selectBtn.isSelected = selectAllBtn.isSelected ? true : false
            
            if indexPath.row == 2 {
                cell.planedView.isHidden = true
                cell.workTimeView.isHidden = true
            }else{
                cell.planedView.isHidden = false
                cell.workTimeView.isHidden = false
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 2:
            let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
            if let absenceVC = storyBoard.instantiateViewController(withIdentifier: "AbsenceDetailsVC") as? AbsenceDetailsVC{
                self.navigationController?.pushViewController(absenceVC, animated: true)
            }
        default:
            let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
            if let timeSheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetDetailsVC") as? TimesheetDetailsVC{
                self.navigationController?.pushViewController(timeSheetVC, animated: true)
            }
        }
    }
    
}
