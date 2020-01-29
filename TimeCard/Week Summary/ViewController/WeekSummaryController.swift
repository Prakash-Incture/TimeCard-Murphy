//
//  WeekSummaryController.swift
//  TimeCard
//
//  Created by prakash on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
class WeekSummaryController: BaseViewController,SAPFioriLoadingIndicator {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    //Variables
    var currentPage: CurrentPage = CurrentPage.weekSummaryOffline
    var currentHeaderCells: [[CellModel]] = CurrentPage.weekSummaryOffline.getCurrentPageHeaders()
    var allocationViewModel:AllocationDataViewModel?
    var allocationOnlineViewModel: AllocationDataViewModel?
    var stringHelper = StringColorChnage()
    var loadingIndicator: FUILoadingIndicatorView?
    var timeSheetObject = [EmployeeTimeSheetDetailDataModel]()
    var weekSummaryWeekData = [WeekSummary]()
    var showLoadingIndicator: Bool? {
           didSet {
               if showLoadingIndicator == true {
                   self.showFioriLoadingIndicator("Loading")
               } else {
                   self.hideFioriLoadingIndicator()
               }
           }
       }
    lazy var empTimeOffSheetAPi = RequestManager<EmployeeTimeOffDataModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationType = .navBackWithAction
        self.allocationViewModel = AllocationDataViewModel(delegate: self)
        self.allocationOnlineViewModel = AllocationDataViewModel(delegate: self)
        self.allocationOnlineViewModel?.allcationModelData.weekData = []
        self.allocationOnlineViewModel?.allcationModelData.weekData = self.weekSummaryWeekData

       // self.getEmpTimeSheetAPICall()
        
    }
    override func selectedAction(sender: UIButton) {

        self.onTapofAction(sender: sender)
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allocationViewModel?.fetchWeekData()
        //self.allocationOnlineViewModel?.fetchOnlineWeekData()
        
        if self.allocationViewModel?.allcationModelData.weekData?.isEmpty ?? true{
            self.customNavigationType = .navWithBack
        }else{
            self.customNavigationType = .navBackWithAction
        }

        self.tableView.isHidden = self.allocationViewModel?.allcationModelData.weekData?.isEmpty ?? true && self.allocationOnlineViewModel?.allcationModelData.weekData?.isEmpty ?? true ? true : false
        self.setUpNavigation()
    }
    func setUpNavigation(){
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "AllocatedTimeTableCell", bundle: nil), forCellReuseIdentifier: "AllocatedTimeTableCell")
        self.tableView.register(UINib(nibName: "WeekSummaryCell", bundle: nil), forCellReuseIdentifier: "WeekSummaryCell")
//        let filterItem = UIBarButtonItem.init(title:"Action", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onTapofAction))
//        navigationItem.rightBarButtonItem = filterItem
        self.navigationItem.title = "Week Summary"
    }
}
// MARK: - Table view data source
extension WeekSummaryController:UITableViewDelegate,UITableViewDataSource{
   func numberOfSections(in tableView: UITableView) -> Int {
    return currentHeaderCells.count
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
        return currentHeaderCells[section].count
    case 1:
        return (self.allocationViewModel?.allcationModelData.weekData?.count ?? 0)
    case 2:
        return (self.allocationOnlineViewModel?.allcationModelData.weekData?.count ?? 0)
    default:
        return 0
    }
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0{
        let cellModel = currentHeaderCells[indexPath.section][indexPath.row] as CellModel
        switch cellModel.reuseIdentifier {
        case .WeekSummaryCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? WeekSummaryCell else { fatalError("Textfield cell not found") }
            cell.setModel(cellModel)
            cell.allocationData = self.allocationViewModel?.allcationModelData
            cell.selectionStyle = .none
            return cell
        case .AllocatedTimeTableCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? AllocatedTimeTableCell else { fatalError("Textfield cell not found") }
            cell.allocationViewModel = self.allocationViewModel
            return cell
        case .GenericTableviewDropdownCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"GenericTableviewDropdownCell") as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            return cell
        }
      }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"WeekSummaryCell") as? WeekSummaryCell else { fatalError("Textfield cell not found") }
        var tempVal: WeekSummary?
        if indexPath.section == 1{
            tempVal = self.allocationViewModel?.allcationModelData.weekData?[indexPath.row]
        }else{
            tempVal = self.allocationOnlineViewModel?.allcationModelData.weekData?[indexPath.row]
        }
             cell.titleText.text = "\(tempVal?.day ?? "")\n\(tempVal?.date ?? "")"
            cell.labelData.text = tempVal?.hours ?? ""
        let highlightColor: UIColor = tempVal?.isAbsence ?? false ? .red : .lightGray
            cell.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: tempVal?.hours ?? "", secondString: "", firstColor: highlightColor, secondColor: highlightColor)
             return cell
        }
   }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if section == 0{
               let _: CGRect = tableView.frame
               let headerView = (Bundle.main.loadNibNamed("Headercell", owner: self, options: nil)?[1] as? WeekHaderCell)
            
            let first_Date = DataSingleton.shared.selectedWeekDates?.first
            let last_Date = DataSingleton.shared.selectedWeekDates?.last
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            let max_Date = formatter.string(from: last_Date!)
            let min_Date = formatter.string(from: first_Date!)
            headerView?.labelText.text = min_Date + " - " + max_Date
            
               headerView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
               return headerView
           }
           return nil
       }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return (self.allocationViewModel?.allcationModelData.weekData?.count ?? 0) > 0 ? CurrentPage.weekSummaryOffline.titleForHeaderInSection(section: section) : ""
        case 2:
            return (self.allocationOnlineViewModel?.allcationModelData.weekData?.count ?? 0) > 0 ? CurrentPage.weeksummarySubmitted.titleForHeaderInSection(section: section) : ""
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
          case 1:
            return (self.allocationViewModel?.allcationModelData.weekData?.count ?? 0) > 0 ? 40.0 : 0.0
            case 2:
            return (self.allocationOnlineViewModel?.allcationModelData.weekData?.count ?? 0) > 0 ? 40.0 : 0.0
          default:
            return 30.0
          }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weekModel: WeekSummary?
        if indexPath.section != 0 && indexPath.section != 2{
            weekModel = self.allocationViewModel?.allcationModelData.weekData?[indexPath.row]
//            navigateToEdit(weekModel: weekModel ?? WeekSummary())
        }
    }
    
    func navigateToEdit(weekModel: WeekSummary) {
        if weekModel.isAbsence ?? false{
            let tempData = weekModel
            guard let absenceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbsencesViewController") as? AbsencesViewController else { return }
//            var absenceModel = Absence()
//
//            if tempData?.timeType != nil{
//                absenceVC.absenceData = tempData ?? Absence()
//            }
            absenceVC.sendBack = {
                self.navigationController?.popViewController(animated: false)
            }
            self.navigationController?.pushViewController(absenceVC, animated: true)
            self.view.endEditing(true)
        }
    }
 }
extension WeekSummaryController{
    @objc func onTapofAction(sender:UIButton) {
          let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
          
          let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          })
          
          let submit = UIAlertAction(title: "Submit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.postTimeSheetData()
          })
          cancel.setValue(UIColor.red, forKey: "titleTextColor")
          submit.setValue(UIColor.blue, forKey: "titleTextColor")
          alertController.addAction(cancel)
          alertController.addAction(submit)
          self.present(alertController, animated: true, completion: nil)
          
       }
}
extension WeekSummaryController:GenericViewModelProtocol{
    func failedWithReason(message: String) {
        DispatchQueue.main.async {
            self.showAlert(message: message)
        }
    }
    
    func didReceiveResponse() {
        self.tableView.reloadData()
    }
}
extension WeekSummaryController{
    func getEmpTimeOffSheetAPICall(){
           self.showLoadingIndicator = true
        let startDate = DataSingleton.shared.selectedWeekDates?.first?.toDateFormat(.yearMonthDateTime)
        let endDate = DataSingleton.shared.selectedWeekDates?[1].toDateFormat(.yearMonthDateTime)
        let dataDict = [
                  "userId" : UserData().userId ?? "",
                  "Start_Date": startDate,
                  "End_Date": endDate
              ]
        self.empTimeOffSheetAPi.getEmployeeTimeOffSheet(for:dataDict as [String : Any], completion: { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .failure(let message):
                   self.showLoadingIndicator = false
               case .success(let value, let message):
                   print(message as Any)
                   self.showLoadingIndicator = false
               case .successData( _): break
                   // Get success data here
               }
           })
       }
    
    func postTimeSheetData(){
        DispatchQueue.main.async {
            SDGEProgressView.startLoader("")
        }
        let dispatchQueue = DispatchQueue(label: "taskQueue")
                      let myGroup = DispatchGroup()
                      let dispatchSemaphore = DispatchSemaphore(value: 0)
               dispatchQueue.async {
        for item in (self.allocationViewModel?.allcationModelData.weekData) ?? [WeekSummary](){
            myGroup.enter()
            if item.isAbsence == false{
            let startdate = item.date?.convertToDate(format: .dayMonthYear, currentDateStringFormat: .dayMonthYear)
              let externalTimeDict : [String: Any] = [
                "externalCode": "\(item.uniqueId)",
                      "hours": item.durationValueInHours ?? "",
                      "costCenter": item.costCenterId ?? "",
                      "timeType": item.timeTypeId ?? "",
                      "userId": UserData().userId ?? "",
                      "startDate": startdate?.toDateFormat(.yearMonthDateTime) ?? ""
            
              ]
              let dataDict : [String : Any] = ["ExternalTimeData": externalTimeDict]
              self.empTimeOffSheetAPi.postTimeSheetEntry(for: dataDict, completion: { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .failure(let message):
                    dispatchSemaphore.signal()
                    myGroup.leave()
                  case .success(let value, let message):
                      print(message as Any)
                    dispatchSemaphore.signal()
                    myGroup.leave()
                  case .successData( _): break
                    
                      // Get success data here
                  }
              })
        }else{
                let startdate = item.startDate?.convertToDate(format: .dayMonthYear, currentDateStringFormat: .dayMonthYear)
                 let endDate = item.endDate?.convertToDate(format: .dayMonthYear, currentDateStringFormat: .dayMonthYear)
            let employeeDataDict : [String:Any] = [
                         "startDate": startdate?.toDateFormat(.yearMonthDateTime) ?? "",
                         "endDate": endDate?.toDateFormat(.yearMonthDateTime) ?? "",
                         "externalCode": "\(item.uniqueId)",
                         "fractionQuantity": item.hours ?? "",
                         "userId": UserData().userId ?? "",
                         "timeType": item.timeTypeId ?? ""
                    ]
                let dataDict : [String : Any] = ["EmployeeTime":employeeDataDict]
                self.empTimeOffSheetAPi.postTimeOffEntry(for: dataDict, completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let message):
                        dispatchSemaphore.signal()
                        myGroup.leave()
                    case .success(let value, let message):
                        print(message as Any)
                        dispatchSemaphore.signal()
                        myGroup.leave()
                    case .successData( _): break
                        // Get success data here
                    }
                })
        }
            dispatchSemaphore.wait()
        }
        }
        myGroup.notify(queue: dispatchQueue) {
                    DispatchQueue.main.async {
                            SDGEProgressView.stopLoader()
                        self.showAlert(message: "Successful")
                    }
             }

    }
}
