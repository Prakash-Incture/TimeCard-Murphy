//
//  TimesheetDetailsVC.swift
//  TimeCard
//
//  Created by PremKumar on 08/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class TimesheetDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var empImgView: UIImageView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var empPositionLbl: UILabel!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var initiatedBtLbl: UILabel!
    @IBOutlet weak var plannedLbl: UILabel!
    @IBOutlet weak var initiatedDateLbl: UILabel!
    @IBOutlet weak var workingTimeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!

    //Variables
    let tempHeader = ["Time Sheet Entry", "", "Time Valuation Result", ""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    func initialSetup() {

        self.tableView.register(UINib(nibName: "TImeSheetEntryCell", bundle: nil), forCellReuseIdentifier: "TImeSheetEntryCell")
        self.tableView.register(UINib(nibName: "TimeValuationCell", bundle: nil), forCellReuseIdentifier: "TimeValuationCell")
        empImgView.layer.cornerRadius = empImgView.frame.width/2
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (declineAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Approve", style: .default, handler: { (approveAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension TimesheetDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tempHeader[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0,1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TImeSheetEntryCell") as? TImeSheetEntryCell{
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeValuationCell") as? TimeValuationCell{
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}