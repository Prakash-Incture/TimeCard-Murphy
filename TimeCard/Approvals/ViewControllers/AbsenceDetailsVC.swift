//
//  AbsenceDetailsVC.swift
//  TimeCard
//
//  Created by PremKumar on 10/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
class AbsenceDetailsVC: BaseViewController,SAPFioriLoadingIndicator {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var empImgView: UIImageView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var empPositionLbl: UILabel!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var initiatedBtLbl: UILabel!
    @IBOutlet weak var initiatedDateLbl: UILabel!
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
    var absenceViewModel = AbsenceDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationType = .navBackWithAction
        self.initialSetup()
    }
    
    func initialSetup() {
        self.tableView.register(UINib(nibName: "KeyValueCell", bundle: nil), forCellReuseIdentifier: "KeyValueCell")
        empImgView.layer.cornerRadius = empImgView.frame.width/2
        absenceViewModel.getTemData(data: timeSheetData)
        self.periodLbl.text = timeSheetData?.peroid ?? ""
        self.statusLbl.text = timeSheetData?.approvalStatus ?? ""
        self.initiatedDateLbl.text = timeSheetData?.wfRequestUINav?.receivedOn ?? ""
        self.empPositionLbl.text = timeSheetData?.wfRequestUINav?.jobTitle ?? ""
        self.empNameLbl.text = timeSheetData?.wfRequestUINav?.subjectUserName ?? ""
        self.initiatedBtLbl.text = timeSheetData?.wfRequestUINav?.subjectUserName ?? ""
 
        tableView.reloadData()
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
            case .failure(_):
                self.showLoadingIndicator = false
            case .successData(value: _):
                self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    self.showAlert(message: "Successful")
                }
            case .success(_, _):
                self.showLoadingIndicator = false
            }
        })
    }

    func callApprovalRequestAPI(id:String){
        self.postApproval.callApproveRequestAPI(id: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure( _):
                self.showLoadingIndicator = false
            case .successData(value:  _):
                self.showLoadingIndicator = false
            case .success( _,  _):
                self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    self.showAlert(message: "Successful")
                }
            }
        })
    }

}

extension AbsenceDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return absenceViewModel.absenceDetailsModel.absenceDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   " + (self.timeSheetData?.wfRequestUINav?.objectType ?? "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueCell") as? KeyValueCell{
                    let dataModel = absenceViewModel.absenceDetailsModel.absenceDetails?[indexPath.row]
                    cell.keyLbl.text = dataModel?.key ?? ""
                    cell.valueLbl.text = dataModel?.value ?? ""
                    return cell
                }
            return UITableViewCell()
    }
    
}
