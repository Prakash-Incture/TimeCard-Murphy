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
    var employeeDetails : EmployeeDetails?
    var isUserAllowToSubmitTimeSheet = false
    var plannedHour = ""
    var startWeekDay = 1
    var workingDayStartFrom = ""
    var workSheduledData : [WorkScheduleDetailDataModel]?
    lazy var holidayCalender = RequestManager<HolidayAssignment>()
    lazy var empTimeAPi = RequestManager<EmpJobModel>()
    lazy var workScheduleAPI = RequestManager<WorkScheduleModel>()
    lazy var empTimeSheetAPi = RequestManager<EmployeeTimeSheetModel>()
    var timeSheetObject = [EmployeeTimeSheetDetailDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = homeScreenTitle
        self.setupViewModel()
        self.loadOfflineStores()
        self.holidayCalenderApicalling()
//        self.allocationViewModel?.fetchDayData()
       // self.customNavigationType = .navPlain
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allocationViewModel?.delegate = self
        self.configurTableView()
        self.allocationViewModel?.fetchDayData()
    }
    
    private func setupViewModel() {
        self.allocationViewModel = AllocationDataViewModel(delegate: self)
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

    func empJobAPICalling(){
        self.showLoadingIndicator = true
        self.empTimeAPi.fetchEmpJob(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
                self.getEmpWorkScheduleAPICall()
            case .success(let value, let message):
                print(message as Any)
                self.employeeDetails = value?.EmpJob?.EmpJob
                self.workingDayStartFrom = value?.EmpJob?.EmpJob?.timeRecordingProfileCode ?? ""
                self.isUserAllowToSubmitTimeSheet = value?.EmpJob?.EmpJob?.timeRecordingProfileCode == "" || value?.EmpJob?.EmpJob?.timeRecordingProfileCode == nil ? false : true
                    
                if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Friday") == true{
                    self.startWeekDay = 6
                }else if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Saturday") == true{
                     self.startWeekDay = 7
                }else if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Sunday") == true{
                     self.startWeekDay = 1
                }else if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Monday") == true{
                     self.startWeekDay = 2
                }else if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Tuesday") == true{
                     self.startWeekDay = 3
                }else if value?.EmpJob?.EmpJob?.timeRecordingProfileCode?.contains("Wednesday") == true{
                     self.startWeekDay = 4
                }else{
                     self.startWeekDay = 5
                }
                self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.getEmpWorkScheduleAPICall()
            case .successData( _): break
                // Get success data here
            }
        })
    }
    func getEmpWorkScheduleAPICall(){
         self.showLoadingIndicator = true
         self.workScheduleAPI.fetchEmpWorkSchedule(for:userData ?? UserData(), completion: { [weak self] result in
             guard let self = self else { return }
             switch result {
             case .failure(_):
                 self.showLoadingIndicator = false
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
                self.getEmpTimeSheetAPICall()

             case .success(let value, let message):
                 print(message as Any)
                 self.showLoadingIndicator = false
                 self.workSheduledData = value?.WorkScheduleDay?.WorkScheduleDay
                 self.plannedHour = value?.WorkScheduleDay?.WorkScheduleDay?.first?.workingHours ?? ""
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
                 self.getEmpTimeSheetAPICall()
             case .successData( _): break
                 // Get success data here
             }
         })
     }
    func holidayCalenderApicalling(){
        self.showLoadingIndicator = true
        self.holidayCalender.holidayCalenderApicall(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure( _):
                self.showLoadingIndicator = false
                self.empJobAPICalling()

                break
            case .success(let value, let message):
                print(message as Any)
                self.showLoadingIndicator = false
                self.holidaycalnder = value?.holidayAssignment?.holidayDataAssignment?.compactMap({$0.date?.replacingOccurrences(of: "T00:00:00.000", with: "")}) as NSArray? ?? []
           
                self.empJobAPICalling()
                break
            case .successData( _): break
                // Get success data here
            }
        })
    }
    func getEmpTimeSheetAPICall(){
           self.showLoadingIndicator = true
        let startDate = DataSingleton.shared.selectedWeekDates?.first?.toDateFormat(.yearMonthDateTime)
        let endDate = DataSingleton.shared.selectedWeekDates?[1].toDateFormat(.yearMonthDateTime)
        let dataDict = [
            "userId" : UserData().userId ?? "",
            "Start_Date": startDate,
            "End_Date": endDate
        ]
        self.empTimeSheetAPi.getEmployeeTimeSheet(for:dataDict as [String : Any], completion: { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .failure(let message):
                   self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               case .success(let value, let message):
                   print(message as Any)
                   self.showLoadingIndicator = false
                  // self.mainupulateData(value: value)
               case .successData(let value):
                self.showLoadingIndicator = false
               do {
                self.timeSheetObject.removeAll()
                let jsonObject = try JSONSerialization.jsonObject(with: value, options: .allowFragments)
                let data = jsonObject as? [String:Any]
                let employeeTimeData = data?["EmployeeTimeSheet"] as? [String:Any]
                var empData  = employeeTimeData?["EmployeeTimeSheet"]
                if empData is Array<Any>{
                    let empDataArr = empData as? [[String:Any]]
                    for item in empDataArr!{
                        var object = EmployeeTimeSheetDetailDataModel()
                        object.period = item["period"] as? String
                        object.absencesExist = item["absencesExist"] as? String
                        object.endDate = item["endDate"] as? String
                        object.startDate = item["startDate"] as? String
                        object.plannedHoursAndMinutes = item["plannedHoursAndMinutes"] as? String
                        object.recordedHoursAndMinutes = item["recordedHoursAndMinutes"] as? String
                        var approveStatusNav = ApprovalStatusNav()
                        var approveObj = ApprovalStatusNavDeatailModel()
                        let statObj = item["approvalStatusNav"] as? [String: Any]
                        let st = statObj?["MDFEnumValue"] as?  [String:Any]
                        approveObj.en_US = st?["en_US"] as? String
                        approveStatusNav.MDFEnumValue = approveObj
                        object.approvalStatusNav = approveStatusNav
                        var entry = EmployeeTimeSheetEntryModel()
                        var timeEntry = [EmployeeTimeSheetEntryDataModel]()
                        let employeeTimeEntry = item["employeeTimeSheetEntry"]
                        if employeeTimeEntry is Dictionary<AnyHashable,Any>{
                            let empEntry = employeeTimeEntry as? [String: Any]
                            if empEntry?["EmployeeTimeSheetEntry"] is Array<Any>{
                                let emmpArr = empEntry?["EmployeeTimeSheetEntry"] as? [[String:Any]]
                                for item in emmpArr!{
                                    var timeObject = EmployeeTimeSheetEntryDataModel()
                                    timeObject.costCenter = item["costCenter"] as? String
                                    timeObject.startDate = item["startDate"] as? String
                                    timeObject.timeTypeName = item["timeTypeName"] as? String
                                    timeObject.quantityInHours = item["quantityInHours"] as? String
                                    timeObject.quantityInHoursAndMinutes = item["quantityInHoursAndMinutes"] as? String
                                    timeEntry.append(timeObject)
                                }
                            }
                        }
                        entry.EmployeeTimeSheetEntry = timeEntry
                        object.employeeTimeSheetEntry = entry
                        self.timeSheetObject.append(object)
                    }
                    
                }else{
                    var empData  = employeeTimeData?["EmployeeTimeSheet"] as? [String:Any]
                    var object = EmployeeTimeSheetDetailDataModel()
                    object.period = empData?["period"] as? String
                                         object.absencesExist = empData?["absencesExist"] as? String
                                         object.endDate = empData?["endDate"] as? String
                                         object.startDate = empData?["startDate"] as? String
                                         object.plannedHoursAndMinutes = empData?["plannedHoursAndMinutes"] as? String
                                         object.recordedHoursAndMinutes = empData?["recordedHoursAndMinutes"] as? String
                                         var approveStatusNav = ApprovalStatusNav()
                                         var approveObj = ApprovalStatusNavDeatailModel()
                                         let statObj = empData?["approvalStatusNav"] as? [String: Any]
                                         let st = statObj?["MDFEnumValue"] as?  [String:Any]
                                         approveObj.en_US = st?["en_US"] as? String
                                         approveStatusNav.MDFEnumValue = approveObj
                                         object.approvalStatusNav = approveStatusNav
                    var entry = EmployeeTimeSheetEntryModel()
                    var timeEntry = [EmployeeTimeSheetEntryDataModel]()
                    let employeeTimeEntry = empData?["employeeTimeSheetEntry"]
                    if employeeTimeEntry is Dictionary<AnyHashable,Any>{
                        let empEntry = employeeTimeEntry as? [String: Any]
                        if empEntry?["EmployeeTimeSheetEntry"] is Array<Any>{
                            let emmpArr = empEntry?["EmployeeTimeSheetEntry"] as? [[String:Any]]
                            for item in emmpArr!{
                                var timeObject = EmployeeTimeSheetEntryDataModel()
                                timeObject.costCenter = item["costCenter"] as? String
                                timeObject.startDate = item["startDate"] as? String
                                timeObject.timeTypeName = item["timeTypeName"] as? String
                                timeObject.quantityInHours = item["quantityInHours"] as? String
                                timeObject.quantityInHoursAndMinutes = item["quantityInHoursAndMinutes"] as? String
                                timeEntry.append(timeObject)
                            }
                            entry.EmployeeTimeSheetEntry = timeEntry
                            object.employeeTimeSheetEntry = entry
                            self.timeSheetObject.append(object)
                        }else{
                            self.timeSheetObject.append(object)
                        }
                    }
                }
                

                   } catch let myJSONError {
                       print(myJSONError)
                   }

                break
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
    func manipulateTimeSheetData(date:Date){
        self.allocationViewModel?.allcationModelData.weekData?.removeAll()
        let data = self.timeSheetObject.first
        if data?.employeeTimeSheetEntry?.EmployeeTimeSheetEntry != nil{
        for item in (data?.employeeTimeSheetEntry?.EmployeeTimeSheetEntry)!{
            var startDate = Date()
            let count = item.startDate?.count
            if count == 23{
                startDate = (item.startDate?.convertToDate(format: .yearMonthDateTimesec, currentDateStringFormat: .yearMonthDateTimesec))!

            }else if count == 22{
                startDate = (item.startDate?.convertToDate(format: .yearMonthDateTimese, currentDateStringFormat: .yearMonthDateTimese))!

            }else if count == 19{
                startDate = (item.startDate?.convertToDate(format: .yearMonthDateTime, currentDateStringFormat: .yearMonthDateTime))!

            }
            let startStringDate = startDate.toDateFormat(.dayMonthYear)
            let selecteddate = date.toDateFormat(.dayMonthYear)
            if selecteddate == startStringDate{
                var weekSummaryData = WeekSummary()
                weekSummaryData.day = self.allocationViewModel?.getdayWeekDay(date:(startDate as Date?) ?? Date())
                weekSummaryData.duration = (Int(Double(item.quantityInHours ?? "0.0")!) * 60)
                weekSummaryData.hours = (item.quantityInHours ?? "") + " " + "Hrs"
                weekSummaryData.date = startStringDate
                self.allocationViewModel?.allcationModelData.weekData?.append(weekSummaryData)
            }
        }
    }
        self.allocationViewModel?.allcationModelData.weekData?.append(WeekSummary())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            DataSingleton.shared.selectedDate = cell.calenderView.selectedDate?.getUTCFormatDate() as NSDate?
            cell.allocationHourPersistence = self.allocationHourPersistence
            cell.datesWithMultipleEvents = self.holidaycalnder
            cell.calenderView.firstWeekday = UInt(startWeekDay)
            cell.dayChanges(day: startWeekDay)
            cell.selecedDateValues = { index,date in
                if index < 0{
                    self.plannedHour = self.workSheduledData?[0].workingHours ?? ""
                }else{
                    self.plannedHour = self.workSheduledData?[index].workingHours ?? ""
                }
                self.manipulateTimeSheetData(date:date)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            cell.clickOption = {
                self.getEmpTimeSheetAPICall()
            }
            if let dataArray = self.allocationViewModel?.allcationModelData.weekData{
                var totalMins: Int = 0
                for data in dataArray{
                    if !(data.isAbsence ?? false){
                        totalMins = totalMins+(data.duration ?? 0)
                    }else{
                        totalMins = totalMins-(data.duration ?? 0)
                    }
                }
                var (hours, min) = Date.minutesToHoursMin(minutes: totalMins)
                hours = hours<0 ? 0 : hours
                min = min<0 ? 0 : min
                cell.recordedHours.text = String(format: "%02d:%02d", hours, abs(min))
            }
            cell.plannedHourLbl.text = "Planned time \(self.plannedHour) hours"
            cell.datelabel.text = DataSingleton.shared.dateText
           // cell.datesWithMultipleEvents = self.allocationViewModel?.holidaycalnder
            return cell
        }else{
            if  self.allocationViewModel?.allcationModelData.weekData?.count == nil || ((self.allocationViewModel?.allcationModelData.weekData?.count ?? 0) - 1) == indexPath.row{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
                cell.newRecordingBtn.isHidden = !isUserAllowToSubmitTimeSheet
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
}

