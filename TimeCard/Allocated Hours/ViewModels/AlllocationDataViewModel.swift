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
    var absenceData:Absence?
    var timeTypeLookUpdata:TimeAndAbsenceLookUp?
    var empTimeOffBalance:EmpTimeAccountBalance?
    var empJobData:EmpJobModel?
    var holidayCalenderData:HolidayAssignment?
    var holidaycalnder:NSArray = []
    
    var userData:UserData?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        formatter.timeZone = TimeZone(secondsFromGMT:Int(5.30))
        return formatter
    }()
    init(delegate:GenericViewModelProtocol) {
        self.delegate = delegate
    }
    
    lazy var requestManger = RequestManager<TimeAndAbsenceLookUp>()
    lazy var requestMangerTimeOffBalance = RequestManager<EmpTimeAccountBalance>()
    lazy var empJObData = RequestManager<EmpJobModel>()
    lazy var holidayCalender = RequestManager<HolidayAssignment>()
    var allocationHourPersistence:AllocationHoursCoreData?
   
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
        if self.allcationModelData.weekData == nil{
           self.allcationModelData.weekData = []
        }
        self.allcationModelData.weekData?.removeAll()
        for value in (weekDays.object as? [AllocationOfflineData]) ?? []{
            print(value)
                guard let allocationModel = allocationHourPersistence?.unarchive(allocationData: value.allocationModel ?? Data()) else {return}
               self.allcationModelData.weekData?.append(self.weekSummaryModel(value: allocationModel))
               self.delegate?.didReceiveResponse()
            }
        self.allcationModelData.weekData?.append(WeekSummary())
        }
    //Changing the Model to other Model to add data
       func weekSummaryModel(value:AllocationModel) -> WeekSummary{
        let weekValues = WeekSummary(day:self.getdayWeekDay(date:(DataSingleton.shared.selectedDate as Date?) ?? Date()), date: self.dateFormatter.string(from:(DataSingleton.shared.selectedDate as Date?) ?? Date()), hours: value.duration)
        return weekValues
       }
    public func dataAdding(){
        let tempData = AllocationModel(timeType: "", duration: "", costCneter: "")
        self.allcationModelData.alllocationModel?.append(tempData)

    }
    public func fetchWeekData(){
        if self.allcationModelData.weekData == nil{
            self.allcationModelData.weekData = []
            self.allcationModelData.weekData?.append(WeekSummary())
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let result = formatter.string(from: (DataSingleton.shared.selectedDate as Date?) ?? Date())
        if let getResult = allocationHourPersistence?.fetchAllFrequesntSeraches(with: NSPredicate(format: "date == %@",result)) as? [AllocationOfflineData]{
            for model in getResult{
                let allocationModel = allocationHourPersistence?.unarchive(allocationData: model.allocationModel ?? Data())
                self.allcationModelData.weekData?.append(self.weekSummaryModel(value: allocationModel!))
                self.delegate?.didReceiveResponse()
            }
        }
    }
}
//Api calling Methods
extension AllocationDataViewModel{
    
    func timeandAbsenseLookUpCalling(){
        self.delegate?.showLoadingIndicator = true
        self.requestManger.fetchlookUpdata(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
                self.timeTypeLookUpdata = value
            }
        })
    }
    func empTimeOffBalanceAPICalling(){
        self.delegate?.showLoadingIndicator = true
        self.requestMangerTimeOffBalance.fetchEmpTimeBalance(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
                self.empTimeOffBalance = value
                UserDefaults.standard.set(value?.empTimeAccountBalance?.empTimeAccountBalanceData?.balance, forKey: "Emp_Leave_Balnce")
                UserDefaults.standard.synchronize()
                self.empJobAPICalling()
            }
        })
    }
    func empJobAPICalling(){
        self.delegate?.showLoadingIndicator = true
        self.empJObData.fetchEmpJob(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
                self.empJobData = value
                self.holidayCalenderApicalling()
            }
        })
    }
    func holidayCalenderApicalling(){
        self.delegate?.showLoadingIndicator = true
        self.holidayCalender.holidayCalenderApicall(for:userData ?? UserData(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .success(let value, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
                self.holidayCalenderData = value
                self.holidaycalnder = self.holidayCalenderData?.holidayAssignment?.holidayDataAssignment?.compactMap({$0.date}) as NSArray? ?? []
                self.delegate?.didReceiveResponse()
                
            }
        })
    }
    func getdayWeekDay(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
}
