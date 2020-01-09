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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalListCell") as? ApprovalListCell{
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
        if let timeSheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetDetailsVC") as? TimesheetDetailsVC{
            self.navigationController?.pushViewController(timeSheetVC, animated: true)
        }
        
    }
    
}
