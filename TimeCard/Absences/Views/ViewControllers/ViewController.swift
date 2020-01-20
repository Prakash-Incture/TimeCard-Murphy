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
    var holidaycalnder:NSArray = []
    var userData:UserData?
    lazy var holidayCalender = RequestManager<HolidayAssignment>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = homeScreenTitle
        self.setupViewModel()
        self.loadOfflineStores()
        self.holidayCalenderApicalling()
        self.allocationViewModel?.fetchDayData()
       // self.customNavigationType = .navPlain
      
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(animated)
        self.allocationViewModel?.delegate = self
        self.configurTableView()
        self.allocationViewModel?.fetchDayData()
    }
    private func setupViewModel() {
        self.allocationViewModel = AllocationDataViewModel(delegate: self)
       // self.allocationViewModel?.empTimeOffBalanceAPICalling() // Uncommand
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
    func holidayCalenderApicalling(){
        self.showLoadingIndicator = true
        self.holidayCalender.holidayCalenderApicall(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
                break
            case .success(let value, let message):
                print(message as Any)
                self.showLoadingIndicator = false
                self.holidaycalnder = value?.holidayAssignment?.holidayDataAssignment?.compactMap({$0.date?.replacingOccurrences(of: "T00:00:00.000", with: "")}) as NSArray? ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case .successData( _): break
                // Get success data here
            }
        })
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
            DataSingleton.shared.selectedDate = cell.calenderView.selectedDate as NSDate?
            cell.allocationHourPersistence = self.allocationHourPersistence
            cell.datesWithMultipleEvents = self.holidaycalnder

            if let dataArray = self.allocationViewModel?.allcationModelData.weekData{
                var totalMins: Int = 0
                for data in dataArray{
                    totalMins = totalMins+(data.duration ?? 0)
                }
                let (hours, min) = ViewController.minutesToHoursMin(minutes: totalMins)
                cell.recordedHours.text = String(format: "%02d:%02d", hours, min)
            }
            
           // cell.datesWithMultipleEvents = self.allocationViewModel?.holidaycalnder
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
                cell.selectionStyle = .none
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
    
    static func minutesToHoursMin(minutes: Int) -> (Int, Int) {
        return (minutes/60, (minutes % 60))
    }
}

