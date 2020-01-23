//
//  AlllocationDataViewModel.swift
//  TimeSheetManagement
//
//  Created by prakash on 02/01/20.
//  Copyright © 2020 prakash. All rights reserved.
//

import Foundation

protocol GenericViewModelProtocol: class {
    var  showLoadingIndicator: Bool? { get set }
    func didReceiveResponse()
    func failedWithReason(message: String)

}
class AllocationDataViewModel{
    weak var delegate: GenericViewModelProtocol?
    var allocationData :AllocationModel?{
        didSet{
            delegate?.didReceiveResponse()
        }
    }
    var allcationModelData = AllocaitonData(){
           didSet{
               delegate?.didReceiveResponse()
           }
       }
    var weekData: WeekSummary?
    var absenceData:Absence?
    var timeTypeLookUpdata:TimeAndAbsenceLookUp?
    var costCenterData = CostCenterData()
    var empTimeOffBalance:EmpTimeAccountBalance?
    var empJobData:EmpJobModel?
    var holidayCalenderData:HolidayAssignment?
    var holidaycalnder:NSArray = []
    var duration:Double = 0
    var plannedhours = 0
    
    var userData:UserData?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        formatter.timeZone = TimeZone(secondsFromGMT:Int(5.30))
        return formatter
    }()
    
    init(delegate:GenericViewModelProtocol) {
        self.loadOfflineStores()
        self.delegate = delegate
    }
    
    lazy var requestMangerTimeOffBalance = RequestManager<EmpTimeAccountBalance>()
    lazy var empJObData = RequestManager<EmpJobModel>()
    lazy var empWorkSche = RequestManager<WorkScheduleModel>()
    lazy var empTimeAPi = RequestManager<EmpJobModel>()
    lazy var holidayCalender = RequestManager<HolidayAssignment>()
    var allocationHourPersistence: AllocationHoursCoreData? = AllocationHoursCoreData(modelName: "AllocatedHoursCoreData")
   
    public func dataFetching(){
        let tempData = AllocationModel(timeType: "", duration: "", costCneter: "")
        self.allcationModelData.alllocationModel = []
        self.allcationModelData.alllocationModel?.append(tempData)
        self.allcationModelData.weekData = []
        var tempWeekData = WeekSummary(day: "Sunday", date: "15/08/2019", hours: "08:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "Monday", date: "16/08/2019", hours: "10:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "Tuesday", date: "17/08/2019", hours: "08:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "WednesDay", date: "18/08/2019", hours: "12:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "ThursDay", date: "19/08/2019", hours: "08:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "Friday", date: "20/08/2019", hours: "06:00")
        self.allcationModelData.weekData?.append(tempWeekData)
        tempWeekData = WeekSummary(day: "Saturaday", date: "21/08/2019", hours: "00:00")
        self.allcationModelData.weekData?.append(tempWeekData)
    }
    public func addingWeekData(weekDays:Notification){
           self.allcationModelData.weekData = []
        self.allcationModelData.weekData?.removeAll()
        for value in (weekDays.object as? [AllocationOfflineData]) ?? []{
            print(value)
            guard let allocationModel = allocationHourPersistence?.unarchive(allocationData: value.allocationModel ?? Data()) else {return}
               self.allcationModelData.weekData?.append(self.weekSummaryModel(value: allocationModel))
               self.delegate?.didReceiveResponse()
            }
        self.allcationModelData.weekData?.append(WeekSummary())
        self.fetchDurationData(weekData: self.allcationModelData.weekData ?? [])
        }
    //Changing the Model to other Model to add data
       func weekSummaryModel(value:AllocationModel) -> WeekSummary{
        //DataSingleton.shared.selectedDate
        let weekValues = WeekSummary(
            day:self.getdayWeekDay(date:(value.selectedDate as Date?) ?? Date()),
            date: self.dateFormatter.string(from:(value.selectedDate as Date?) ?? Date()),
            hours: value.duration,
            duration: value.durationMin,
            selectedDate: value.selectedDate)
        return weekValues
       }
    public func dataAdding(){
        let tempData = AllocationModel(timeType: "", duration: "", costCneter: "")
        self.allcationModelData.alllocationModel?.append(tempData)

    }
    public func fetchDayData(){
        if self.allcationModelData.weekData == nil{
            self.allcationModelData.weekData = []
            self.allcationModelData.weekData?.append(WeekSummary())
        }
        
        let dateFrom = (DataSingleton.shared.selectedDate as Date? ?? Date()).getUTCFormatDate()
        
        if let getResult = allocationHourPersistence?.fetchAllFrequesntSeraches(with: NSPredicate(format: "date == %@", dateFrom as NSDate)) as? [AllocationOfflineData]{
            self.allcationModelData.weekData?.removeAll()
            for model in getResult{
                let allocationModel = allocationHourPersistence?.unarchive(allocationData: model.allocationModel ?? Data())
                self.allcationModelData.weekData?.append(self.weekSummaryModel(value: allocationModel!))
                self.delegate?.didReceiveResponse()
            }
        }
    }
    
    public func fetchWeekData(){
        if self.allcationModelData.weekData == nil{
            self.allcationModelData.weekData = []
            self.allcationModelData.weekData?.append(WeekSummary())
        }
        
        let dateFrom = (DataSingleton.shared.selectedWeekDates?.first as Date? ?? Date()).getUTCFormatDate() // eg. 2016-10-10 00:00:00
        let dateTo = (DataSingleton.shared.selectedWeekDates?.last as Date? ?? Date()).getUTCFormatDate()
        
        if let getResult = allocationHourPersistence?.fetchAllFrequesntSeraches(with: NSPredicate(format: "date >= %@ AND date <= %@", dateFrom as NSDate, dateTo as NSDate)) as? [AllocationOfflineData]{
//            "(date >= %@) AND (date <= %@) AND complete == 0"
            for model in getResult{
                let allocationModel = allocationHourPersistence?.unarchive(allocationData: model.allocationModel ?? Data())
                print(allocationModel?.costCneter ?? "")
                self.allcationModelData.weekData?.append(self.weekSummaryModel(value: allocationModel!))
                self.delegate?.didReceiveResponse()
            }
        }
    }
    func fetchDurationData(weekData:[WeekSummary]){
        duration = 0
        for val in weekData{
            let hourData = self.removeHourText(tempString: val.hours ?? "")
            duration = duration + hourData
//            DataSingleton.shared.totalHours = "0"
        }
//        DataSingleton.shared.totalHours = String(duration) == "0.0" ? "0" : String(duration)
        
    }
    func removeHourText(tempString:String) -> Double{
        if tempString != ""{
        var value = tempString.replacingOccurrences(of: " Hour ", with: ".")
        value = value.replacingOccurrences(of: " Minutes", with: "")
        return Double(value) ?? 0
        }
        return 0
    }
}
//Api calling Methods
extension AllocationDataViewModel{
    
    func empTimeOffBalanceAPICalling(){
        self.delegate?.showLoadingIndicator = true
        self.requestMangerTimeOffBalance.fetchEmpTimeBalance(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
                self.getEmpWorkScheduleAPICall()
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
                self.empTimeOffBalance = value
                let availableBalance = String(format: "%@ %@",value?.empTimeAccountBalance?.empTimeAccountBalanceData?.balance ?? "",value?.empTimeAccountBalance?.empTimeAccountBalanceData?.timeUnit ?? "")
                UserDefaults.standard.set( availableBalance, forKey: "Emp_Leave_Balnce")
                UserDefaults.standard.synchronize()
                self.getEmpWorkScheduleAPICall()
            case .successData(let _): break
                // Get success data here
            }
        })
    }

    func getEmpWorkScheduleAPICall(){
        self.delegate?.showLoadingIndicator = true
        self.empTimeAPi.fetchEmpWorkSchedule(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
            case .successData( _): break
                // Get success data here
            }
        })
    }
    func getdayWeekDay(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    func getNumberOfPlannedHours(totalHours:String,totalWeekhours:String) -> Int{
        plannedhours = (Int(totalWeekhours) ?? 0)/(Int(totalHours) ?? 0)
        return plannedhours
    }
}

extension AllocationDataViewModel {
    func loadOfflineStores() {
        self.allocationHourPersistence?.load { [weak self] in
        }
    }
   
}
