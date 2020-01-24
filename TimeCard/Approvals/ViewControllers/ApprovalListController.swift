//
//  ApprovalListController.swift
//  TimeCard
//
//  Created by prakash on 07/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori

class ApprovalListController: BaseViewController, SAPFioriLoadingIndicator {
    var loadingIndicator: FUILoadingIndicatorView?
    
    @IBOutlet weak var approveViewHtConstarint: NSLayoutConstraint!
    @IBOutlet weak var selectAllTitleLbl: UILabel!
    @IBOutlet weak var selectAllBtnView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    var showLoadingIndicator: Bool? {
           didSet {
               if showLoadingIndicator == true {
                   self.showFioriLoadingIndicator("Loading")
               } else {
                   self.hideFioriLoadingIndicator()
               }
           }
       }
    var approveListViewModel = ApproveListViewModel()
    var dispatchGroup: DispatchGroup = DispatchGroup()
    lazy var getAssertionToken = RequestManager<ApproveListModels>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationType = .navWithFilter
        self.selectAllBtnView.constant = 0
        self.approveViewHtConstarint.constant = 0.0
        self.selectAllBtn.isHidden = true
        self.selectAllTitleLbl.isHidden = true
        self.tableView.isHidden = true
        self.approveBtn.isHidden = true
        self.initialSetup()
        self.setupViewModel()
        self.bindViewModel()
    }
    func bindViewModel(){
        self.approveListViewModel.updateUI = {
            self.selectAllBtnView.constant = 60.0
            self.tableView.isHidden = false
            self.approveBtn.isHidden = false
            self.selectAllBtn.isHidden = false
            self.selectAllTitleLbl.isHidden = false
            self.tableView.reloadData()
            self.showLoadingIndicator = false
        }
        self.approveListViewModel.successfullMess = { mess in
            DispatchQueue.main.async {
                 self.showAlert(message: mess)
            }
              self.showLoadingIndicator = false
        }
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupViewModel() {
        approveListViewModel.tableView = self.tableView
        approveListViewModel.callAPIForGettingAssertionToken()
    }
    override func selectedFilter(sender: UIButton) {
        
    }
    func initialSetup() {
        
        self.tableView.register(UINib(nibName: "ApprovalListCell", bundle: nil), forCellReuseIdentifier: "ApprovalListCell")
        approveBtn.layer.cornerRadius = 5.0
    }
    
    @IBAction func selectAllBtnTapped(_ sender: Any) {
        selectAllBtn.isSelected = !selectAllBtn.isSelected
        for (index,_) in self.approveListViewModel.timeSheetArray.enumerated(){
                self.approveListViewModel.timeSheetArray[index].isSelected = selectAllBtn.isSelected
               }
        if selectAllBtn.isSelected{
             self.approveViewHtConstarint.constant = 60.0
        }else{
             self.approveViewHtConstarint.constant = 0.0
        }
        tableView.reloadData()
    }
    
    @IBAction func approveBtnTapped(_ sender: Any) {
        self.showLoadingIndicator = true
        var count = 0
        var ids = [String]()
        for item in self.approveListViewModel.timeSheetArray{
            if item.isSelected == true{
                count = count + 1
                ids.append(item.subjectId ?? "")
            }
        }
        if count > 1{
            self.approveListViewModel.callApprovelAPIForMultipleSelection(arr: ids)
        }else{
            self.approveListViewModel.callApprovalRequestAPI(id: ids.first ?? "")
        }

    }
    @objc func selectBtnClicked(sender:UIButton){
        if sender.isSelected{
            sender.isSelected = true
            self.approveListViewModel.timeSheetArray[sender.tag].isSelected = true
        }else{
            sender.isSelected = false
            self.approveListViewModel.timeSheetArray[sender.tag].isSelected = false
        }
        self.tableView.reloadData()
    }
    func manipulateUI(index:Int,state:Bool){
        self.approveListViewModel.timeSheetArray[index].isSelected = state
                   var count = 0
                   for item in self.approveListViewModel.timeSheetArray{
                       if item.isSelected == true{
                           count = count + 1
                       }
                   }
                   if count == self.approveListViewModel.timeSheetArray.count{
                       self.selectAllBtn.isSelected = true
                   }else{
                       self.selectAllBtn.isSelected = false
                   }
                   if count == 0{
                       self.approveViewHtConstarint.constant = 0.0
                   }else{
                   self.approveViewHtConstarint.constant = 60.0
                   }
        self.tableView.reloadData()
    }
}

extension ApprovalListController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.approveListViewModel.timeSheetArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 335.0
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalListCell") as? ApprovalListCell{
            let data = self.approveListViewModel.timeSheetArray[indexPath.row]
            cell.selectBtn.isSelected = data.isSelected ?? false
            cell.updateUi = { state in
                self.manipulateUI(index: indexPath.row, state: state)
            }
            cell.selectBtn.addTarget(self, action: #selector(selectBtnClicked), for:.touchUpInside)
            cell.selectBtn.tag = indexPath.row
            if indexPath.row == 2 {
                cell.planedView.isHidden = true
                cell.workTimeView.isHidden = true
            }else{
                cell.planedView.isHidden = false
                cell.workTimeView.isHidden = false
            }
            cell.appNameLbl.text = data.wfRequestUINav?.operateUserName ?? ""
            cell.appPositionLbl.text = data.wfRequestUINav?.jobTitle ?? ""
            cell.initiatedLbl.text = data.wfRequestUINav?.subjectUserId ?? ""
            cell.initiatedDateLbl.text = data.wfRequestUINav?.receivedOn ?? ""
           // let separatedData = data.subjectFullName?.split(separator: "(")
           // let secondSeparatedData = separatedData?[1].split(separator: ")")
           // cell.periodLbl.text = String(secondSeparatedData?.first ?? "")
            for (index,value) in data.wfRequestUINav?.approverChangedData?.enumerated() ?? [ApproverChangedData]().enumerated(){
                if index == 1{
                    cell.periodTitleLbl.text = value.label
                    cell.periodLbl.text = value.newValue
                }else if index == 2{
                    cell.planedTitleLbl.text = value.label
                    cell.planedLbl.text = value.newValue
                }else{
                    cell.workingTimeTitleLbel.text = value.label
                    cell.workTimeLbl.text = value.newValue
                }
            }
           // Annual Leave (01/09/2020 - 01/09/2020): Omar Ahmed Arafa
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.approveListViewModel.timeSheetArray[indexPath.row]
        if data.categoryLabel == "Time Off Requests"{
            let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
            if let absenceVC = storyBoard.instantiateViewController(withIdentifier: "AbsenceDetailsVC") as? AbsenceDetailsVC{
                absenceVC.timeSheetData = self.approveListViewModel.timeSheetArray[indexPath.row]
            self.navigationController?.pushViewController(absenceVC, animated: true)
            }}else{
            let storyBoard = UIStoryboard(name: "Approvals", bundle: nil)
               if let timeSheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetDetailsVC") as? TimesheetDetailsVC{
                   timeSheetVC.timeSheetData = self.approveListViewModel.timeSheetArray[indexPath.row]
                   self.navigationController?.pushViewController(timeSheetVC, animated: true)
                    }
        }
    }
    
}
