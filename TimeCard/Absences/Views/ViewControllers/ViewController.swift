//
//  ViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 31/12/19.
//  Copyright © 2019 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
import CoreData

class ViewController: BaseViewController,SAPFioriLoadingIndicator {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weekSummaryButton: UIButton!
    
    var allocationViewModel:AllocationDataViewModel?
    var stringHelper = StringColorChnage()
    var loadingIndicator: FUILoadingIndicatorView?
    var showLoadingIndicator: Bool? {
           didSet {
               if showLoadingIndicator == true {
                   self.showFioriLoadingIndicator("Loading")
               } else {
                   self.hideFioriLoadingIndicator()
               }
           }
       }
    var allocationHourPersistence = AllocationHoursCoreData(modelName: "AllocatedHoursCoreData")
    var weekSummary:[WeekSummary] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = homeScreenTitle
        self.setupViewModel()
        self.loadOfflineStores()
       // self.customNavigationType = .navPlain
      
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(animated)
        self.allocationViewModel?.delegate = self
        self.configurTableView()
        self.allocationViewModel?.fetchWeekData()
    }
    private func setupViewModel() {
        self.allocationViewModel = AllocationDataViewModel(delegate: self)
        self.allocationViewModel?.empTimeOffBalanceAPICalling()
        }
    func configurTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
          self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
          self.tableView.register(UINib(nibName: "CalenderTableViewCell", bundle: nil), forCellReuseIdentifier: "CalenderTableViewCell")
        self.tableView.register(UINib(nibName: "WeekSummaryCell", bundle: nil), forCellReuseIdentifier: "WeekSummaryCell")
         NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "onTapOfDate"), object: nil, queue: nil) { notification in
           // self.allocationViewModel = AllocationDataViewModel(delegate: self)
            self.allocationViewModel?.allocationHourPersistence = self.allocationHourPersistence
            self.allocationViewModel?.addingWeekData(weekDays:notification)
            self.tableView.reloadData()
            self.removeObserver()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onTapOfBackAction(){
        self.dismiss(animated: true, completion: nil)
    }
   @objc func newRecordBtnClicked(sender:UIButton){
        let storyBoard = UIStoryboard(name: "AllocationHours", bundle: nil)
        let newRecordVC = storyBoard.instantiateViewController(withIdentifier: "NewRecordingViewController") as! NewRecordingViewController
         newRecordVC.allocationDataViewModel = self.allocationViewModel
        newRecordVC.allocationHourPersistence = self.allocationHourPersistence
        self.navigationController?.pushViewController(newRecordVC, animated: true)
    }
    @IBAction func viewWeekSummaryAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "AllocationHours", bundle: nil)
             let newRecordVC = storyBoard.instantiateViewController(withIdentifier: "WeekSummaryController") as! WeekSummaryController
             self.navigationController?.pushViewController(newRecordVC, animated: true)
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        return 1
        }
        return (self.allocationViewModel?.allcationModelData.weekData?.count ?? 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
              let cell = self.tableView.dequeueReusableCell(withIdentifier: "CalenderTableViewCell", for: indexPath) as! CalenderTableViewCell
            cell.selectionStyle = .none
            cell.allocationHourPersistence = self.allocationHourPersistence
            cell.datesWithMultipleEvents = self.allocationViewModel?.holidaycalnder as? [String] ?? []
            return cell
        }else{
            if  self.allocationViewModel?.allcationModelData.weekData?.count == nil || ((self.allocationViewModel?.allcationModelData.weekData?.count ?? 0) - 1) == indexPath.row{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
                cell.newRecordingBtn.addTarget(self, action: #selector(newRecordBtnClicked), for: .touchUpInside)
                return cell
                
            }else{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "WeekSummaryCell", for: indexPath) as! WeekSummaryCell
                let tempVal = self.allocationViewModel?.allcationModelData.weekData?[indexPath.row]
                cell.titleText.text = "\(tempVal?.day ?? "")\n\(tempVal?.date ?? "")"
                cell.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: tempVal?.hours ?? "", secondString: "", firstColor: cell.titleText.textColor, secondColor: UIColor.lightGray)
                cell.accessoryType = .disclosureIndicator
                return cell
                
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0{
            return 80
        }
        return 379
    }
//    func loadTableView(date:Date){
//        self.allocationViewModel = AllocationDataViewModel(delegate: self)
//        self.allocationViewModel?.addingWeekData(weekDays:)
//        self.tableView.reloadData()
//    }
    
}
extension ViewController:GenericViewModelProtocol{
   
    func failedWithReason(message: String) {
       // self.showAlert(message: message)
    }
    
    func didReceiveResponse() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "onTapOfDate"), object: nil)
    }
}
extension ViewController {
    func loadOfflineStores() {
        self.allocationHourPersistence.load { [weak self] in
        }
    }
   
}