//
//  TimesheetDetailsVC.swift
//  TimeCard
//
//  Created by PremKumar on 08/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
class TimesheetDetailsVC: BaseViewController,SAPFioriLoadingIndicator {

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
    var timeSheetData : Results3?
    var loadingIndicator: FUILoadingIndicatorView?
    lazy var postApproval = RequestManager<ApprovalRequestSuccess>()
    var showLoadingIndicator: Bool? {
            didSet {
                if showLoadingIndicator == true {
                    self.showFioriLoadingIndicator("Loading")
                } else {
                    self.hideFioriLoadingIndicator()
                }
            }
        }
    //Variables
    let tempHeader = ["Time Sheet Entry", "", "Time Valuation Result", ""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationType = .navBackWithAction
        self.initialSetup()
    }
    
    func initialSetup() {

        self.tableView.register(UINib(nibName: "TImeSheetEntryCell", bundle: nil), forCellReuseIdentifier: "TImeSheetEntryCell")
        self.tableView.register(UINib(nibName: "TimeValuationCell", bundle: nil), forCellReuseIdentifier: "TimeValuationCell")
        empImgView.layer.cornerRadius = empImgView.frame.width/2        
        self.empNameLbl.text = timeSheetData?.wfRequestUINav?.operateUserName ?? ""
             self.empPositionLbl.text = timeSheetData?.wfRequestUINav?.jobTitle ?? ""
         self.statusLbl.text = timeSheetData?.statusLabel ?? ""
         self.initiatedDateLbl.text = timeSheetData?.wfRequestUINav?.receivedOn ?? ""
         self.initiatedBtLbl.text = timeSheetData?.wfRequestUINav?.subjectUserId ?? ""
         let separatedData = timeSheetData?.subjectFullName?.split(separator: "(")
         let secondSeparatedData = separatedData?[1].split(separator: ")")
         self.periodLbl.text = String(secondSeparatedData?.first ?? "")
        
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    override func selectedAction(sender: UIButton) {
                let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (declineAction) in
            self.callApprovalRejectAPI(id: self.timeSheetData?.subjectId ?? "")
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Approve", style: .default, handler: { (approveAction) in
            self.callApprovalRequestAPI(id: self.timeSheetData?.subjectId ?? "")
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func callApprovalRejectAPI(id:String){
        self.postApproval.callApproveRejectAPI(id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
            case .successData(value: let value):
                self.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.showLoadingIndicator = false
            }
        })
    }

    func callApprovalRequestAPI(id:String){
        self.postApproval.callApproveRequestAPI(id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
            case .successData(value: let value):
                self.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.showLoadingIndicator = false
            }
        })
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
