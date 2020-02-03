//
//  AbsencesViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
import CoreData

class AbsencesViewController: BaseViewController,SAPFioriLoadingIndicator {
    
    var datePickerView =  UIDatePicker()
    var hoursPickerView =  UIPickerView()
    @IBOutlet weak var tableView: UITableView!
    lazy var getAssertionToken = RequestManager<ApproveListModels>()
    lazy var postAbsenceDataCall = RequestManager<ApproveListModels>()
    lazy var requestMangerTimeOffBalance = RequestManager<EmpTimeAccountBalance>()

    var idpPayload: GetIDPPayload?
    var currentHeaderCells: [CellModelForAbsence] = AbsenceCurrentPage.absenceRecording.getCurrentPageHeaders()
    var allocationDataViewModel:AllocationDataViewModel!
    var absenceData = Absence()
    var hour:String = ""
    var userData:UserData?
    var allocationHourPersistence = AllocationHoursCoreData(modelName: "AllocatedHoursCoreData")
    var balanceHour = " "
    var sendBack : (()->())?
    var loadingIndicator: FUILoadingIndicatorView?
    var showLoadingIndicator: Bool? {
        didSet {
            if showLoadingIndicator == true {
                self.showFioriLoadingIndicator("Loding")
            } else {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    var startDate = Date()
    var endDate = Date()
    var stringHelper = StringColorChnage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Absences"
        self.customNavigationType = .navWithBack
        if (self.currentHeaderCells.count ) != 4{
            self.currentHeaderCells.remove(at: 1)
        }
        self.loadOfflineStores()
        setupTableViewConfigur()
        self.userData = UserData()
       // callAPIForGettingAssertionToken()
    }
    func setupTableViewConfigur(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
        self.tableView.register(UINib(nibName: "GenericTableviewDropdownCell", bundle: nil), forCellReuseIdentifier: "GenericTableviewDropdownCell")
        
        
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func selectedCancel(sender: UIButton) {
        self.customNavigationType = .navWithBack
    }
    
    override func selectedSubmit(sender: UIButton) {
        //        self.postAbsenceData()
        // Static absence duration for 1 day
        let absDuration = DataSingleton.shared.plannedHours
        self.absenceData.duration = "\((absDuration ?? 0)/60) Hours"
        self.absenceData.durationMin = absDuration
        self.absenceData.status = "to be submitted"
        if self.absenceData.uniqueId == nil{
            self.saveOfflineData()
        }else{
            // Update absence model in db
//            updateOfflineModel(updatedData: self.absenceData)
            self.removeOldOfflineAbsences(updatedData: self.absenceData)
            // After remove existing data save updated one
            self.saveOfflineData()
        }
       
    }
    
    func saveOfflineData() {
        let absenceDates = Date.dates(from: self.absenceData.dateStart?.getUTCFormatDate() ?? Date(), to: self.absenceData.dateEnd?.getUTCFormatDate() ?? Date())
        for absenceDate in absenceDates{
            let dateFrom = (absenceDate as Date).getUTCFormatDate()
            
                self.absenceData.uniqueId = Date().timeIntervalSince1970 // Adding unique id
            self.absenceData.selectedDate = dateFrom
                self.allocationHourPersistence.saveAbsenceHour(absenceModel: self.absenceData, withDate: dateFrom)
            self.sendBack?()
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func removeOldOfflineAbsences(updatedData: Absence) {
        // Delete object from local array
        let dataObj = updatedData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllocationOfflineData")
        let predicate = NSPredicate(format: "key == %@", "Absence")
        
        // Delete request for offline object
        self.allocationHourPersistence.removePreviousDataWithUniqueId(fetchRequest: fetchRequest, predicate: predicate, uniqueId: updatedData.uniqueId ?? 0.0, isUpdate: true, absenceModel: updatedData)
        
    }
    
//    func updateOfflineModel(updatedData: Absence) {
//        let dataObj = updatedData
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllocationOfflineData")
//        let predicate = NSPredicate(format: "date == %@ AND key == %@", (dataObj.selectedDate as NSDate?)!, "Absence")
//        self.allocationHourPersistence.updatePreviousDataWithUniqueId(fetchRequest: fetchRequest, predicate: predicate, uniqueId: updatedData.uniqueId!, updatedObj: updatedData)
//        // self.postAbsenceData()
//        self.sendBack?()
//        self.navigationController?.popViewController(animated: false)
//    }
}
extension AbsencesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentHeaderCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let cellModel = currentHeaderCells[indexPath.row]
        
        cell.selectionStyle = .none
        cell.cellTextField.isUserInteractionEnabled = true
        cell.accessoryType = .disclosureIndicator
        switch cellModel.absenceModelIdentifier {
        case .timeType:
            cell.contentLbl.attributedText = stringHelper.conevrtToAttributedString(firstString: cellModel.absenceModelIdentifier.rawValue, secondString: "*", firstColor: .black, secondColor: .red)
            cell.cellTextField.text =  absenceData.timeType
            cell.cellTextField.addTarget(self, action: #selector(absenceLookUpNavigating), for: .editingDidBegin)
            cell.cellTextField.resignFirstResponder()
            break
        case .availableBalance:
            cell.contentLbl.attributedText = stringHelper.conevrtToAttributedString(firstString: cellModel.absenceModelIdentifier.rawValue, secondString: "", firstColor: .black, secondColor: .red)
            cell.accessoryType = .none
            cell.cellTextField.isUserInteractionEnabled = false
            cell.cellTextField.text = self.balanceHour
            break
        case .startDate:
            cell.contentLbl.attributedText = stringHelper.conevrtToAttributedString(firstString: cellModel.absenceModelIdentifier.rawValue, secondString: "*", firstColor: .black, secondColor: .red)
            cell.cellTextField.text =  absenceData.startDate
            self.setDatePickerView(textField: cell.cellTextField, tag: 1)
            cell.cellTextField.resignFirstResponder()
            
            break
        case .endDate:
            cell.contentLbl.attributedText = stringHelper.conevrtToAttributedString(firstString: cellModel.absenceModelIdentifier.rawValue, secondString: "*", firstColor: .black, secondColor: .red)
            cell.cellTextField.text =  absenceData.endDate
            self.setDatePickerView(textField: cell.cellTextField, tag: 2)
            cell.cellTextField.resignFirstResponder()
            break
        case .requesting:
            cell.contentLbl.attributedText = stringHelper.conevrtToAttributedString(firstString: cellModel.absenceModelIdentifier.rawValue, secondString: "", firstColor: .black, secondColor: .red)
            cell.cellTextField.text = absenceData.requesting ?? "0 Hours"
            cell.cellTextField.isUserInteractionEnabled = false
            self.seytPickerViews(textField:cell.cellTextField)
            break
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
extension AbsencesViewController:UpdateData,UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row + 1) Hours"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hour = String(row + 1) + " " + "Hours"
    }
    
    func updateValue(value: String?,id:String) {
        absenceData.timeType = value ?? ""
        self.tableView.reloadData()
        if (self.currentHeaderCells.count ) != 4{
            self.currentHeaderCells.remove(at: 1)
            self.tableView.reloadData()
        }
    }
    @objc func absenceLookUpNavigating(){
        guard let listVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else { return }
        listVC.delegate = self
        listVC.sendData = { data in
            self.absenceData.timeType = data.externalName_en_US ?? ""
            self.absenceData.timeTypeId = data.timeAccountPostingRules?.TimeAccountPostingRule?.timeAccountType ?? ""
            self.empTimeOffBalanceAPICalling(id: self.absenceData.timeTypeId!)
            self.tableView.reloadData()
//            if (self.currentHeaderCells.count ) != 4{
//                self.currentHeaderCells.remove(at: 1)
//                self.tableView.reloadData()
//            }
        }
        self.navigationController?.pushViewController(listVC, animated: true)
        self.view.endEditing(true)
        return
    }
    func setDatePickerView(textField:UITextField,tag:Int){
        let toolBar = UIToolbar();
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donedatePicker));
        doneButton.tag = tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(named: "02265A")
        toolBar.sizeToFit()
        datePickerView.datePickerMode = .date
        textField.inputView = datePickerView
        textField.inputAccessoryView  = toolBar
    }
    func seytPickerViews(textField:UITextField){
        //ToolBar
        let toolBar = UIToolbar();
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(named: "02265A")
        toolBar.sizeToFit()
        
        hoursPickerView.dataSource = self
        hoursPickerView.delegate = self
        textField.inputView = hoursPickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(){
        absenceData.requesting = (self.hour == "") ? "1 Hours" : hour
        self.tableView.reloadData()
        self.view.endEditing(true)
        if  absenceData.startDate != nil && absenceData.endDate != nil && absenceData.timeType != nil && absenceData.timeType != ""{
            self.customNavigationType = .navWithCancelandSubmit
        }
        
    }
    @objc func donedatePicker(sender: UIBarButtonItem){
        let formatter = DateFormatter()
        formatter.dateFormat = Date.DateFormat.monthDayYear.rawValue
        
        if sender.tag == 1{
            startDate = self.datePickerView.date
            absenceData.dateStart = startDate
            absenceData.startDate = self.datePickerView.date.toDateFormat(.monthDayYear)
        }else{
            endDate = self.datePickerView.date
            absenceData.dateEnd = endDate
            absenceData.endDate = self.datePickerView.date.toDateFormat(.monthDayYear)
        }
        
        let dteDiff = endDate.days(from: startDate) + 1
        absenceData.requesting = "\(dteDiff*(DataSingleton.shared.plannedHours ?? 0)/60) Hours"
        
        if  absenceData.startDate != nil && absenceData.endDate != nil && absenceData.timeType != nil && absenceData.timeType != ""{
            self.customNavigationType = .navWithCancelandSubmit
        }
        self.tableView.reloadData()
        self.view.endEditing(true)
        
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}
extension AbsencesViewController{
    func empTimeOffBalanceAPICalling(id:String){
        let dataDict = [
            "userId": UserData().userId ?? "",
            "timeAccountType":id
        ]
        SDGEProgressView.startLoader("")

        self.requestMangerTimeOffBalance.fetchEmpTimeBalance(for:dataDict, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    if (self.currentHeaderCells.count ) != 4{
                    self.currentHeaderCells.remove(at: 1)
                    self.tableView.reloadData()
                    }
                    SDGEProgressView.stopLoader()
                }
            case .success(let value, let message):
                print(message as Any)
                self.balanceHour = ((value?.EmpTimeAccountBalance?.EmpTimeAccountBalance?.balance ?? "") + " " + (value?.EmpTimeAccountBalance?.EmpTimeAccountBalance?.timeUnit ?? ""))
                if value?.EmpTimeAccountBalance?.EmpTimeAccountBalance?.balance == nil{
                                if (self.currentHeaderCells.count ) != 4{
                                    self.currentHeaderCells.remove(at: 1)
                                }
                }else{
                    if (self.currentHeaderCells.count ) >= 4{
                        self.currentHeaderCells = AbsenceCurrentPage.absenceRecording.getCurrentPageHeaders()
                }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SDGEProgressView.stopLoader()
                }
            case .successData(_): break
                // Get success data here
            }
        })
    }

    func callAPIForGettingAssertionToken() {
        self.showLoadingIndicator = true
        
        let idpBody: [String: String] = ["client_id": clientId, "user_id": "6000193", "token_url": tokenUrl, "private_key": privatekay]
        let idpBodyStr = QHTTPFormURLEncoded.urlEncoded(formDataSet: idpBody)
        
        self.getAssertionToken.fetchAsserionTokenForTimeSheet(for:idpPayload ?? GetIDPPayload(), params: idpBodyStr, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
            case .successData(value: let value):
                let dataStr = String(data: value, encoding: .utf8)!
                UserDefaults.standard.set(dataStr, forKey: assertionTokenForTimeSheet)
                UserDefaults.standard.synchronize()
                self.showLoadingIndicator = false
                self.callAPIForGettingAccessToken()
            case .success( _, let message):
                print(message as Any)
                self.showLoadingIndicator = false
            }
        })
    }
    
    // Get access token
    func callAPIForGettingAccessToken() {
        self.showLoadingIndicator = true
        
        let idpBody: [String: String] = ["client_id": clientId, "grant_type": grantType, "company_id": companyId, "assertion": UserDefaults.standard.object(forKey: assertionTokenForTimeSheet) as? String ?? ""]
        let idpBodyStr = QHTTPFormURLEncoded.urlEncoded(formDataSet: idpBody)
        
        self.getAssertionToken.fetchAccessTokenForTimeSheet(for:idpPayload ?? GetIDPPayload(), params: idpBodyStr, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
            case .successData(value: let value):
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: value, options : .allowFragments) as? Dictionary<String, Any>
                    {
                        UserDefaults.standard.set(jsonObj["access_token"], forKey: accessTokenForTimeSheet)
                        UserDefaults.standard.synchronize()
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            case .success( _, let message):
                print(message as Any)
                self.showLoadingIndicator = false
            }
        })
    }
    
    func postAbsenceData(){
        let externalCode = Int.random(in: 0...100000000)
        let startDate = self.absenceData.startDate?.convertToDate(format: .monthDayYear, currentDateStringFormat: .monthDayYear)?.currentTimeMillis()
        let enddate = self.absenceData.endDate?.convertToDate(format: .monthDayYear, currentDateStringFormat: .monthDayYear)?.currentTimeMillis()
        let difference = Calendar.current.dateComponents([.hour, .minute], from: (self.absenceData.startDate?.convertToDate(format: .monthDayYear, currentDateStringFormat: .monthDayYear))!, to: (self.absenceData.endDate?.convertToDate(format: .monthDayYear, currentDateStringFormat: .monthDayYear))!)
        let formattedString = String(format: "%02ld.%02ld", difference.hour!/3, difference.minute!)
        print(formattedString)
        let dataDictForEmployee:[String:Any] = [
            "uri" : "https://api4preview.sapsf.com/odata/v2/EmployeeTime",
            "type": "SFOData.EmployeeTime"
        ]
        let dataDictForUser:[String:Any] = [
            "uri" : "https://api4preview.sapsf.com/odata/v2/User('\(self.userData?.userId ?? "")')",
            "type": "SFOData.User"
        ]
        let dictForUser:[String:Any] = [
            "__metadata" : dataDictForUser
        ]
        
        let dataDictForTymeType:[String:Any] = [
            "uri" : "https://api4preview.sapsf.com/odata/v2/TimeType('\(self.absenceData.timeTypeId!)')",
            "type": "SFOData.TimeType"
        ]
        let dictForTimeType:[String:Any] = [
            "__metadata" : dataDictForTymeType
        ]
        let dataDict:[String:Any] = [
            
            "__metadata" : dataDictForEmployee,
            "startDate" : "/Date(\(startDate!))/",
            "endDate" : "/Date(\(enddate!))/",
            "externalCode" : "\(externalCode)",
            "fractionQuantity" : formattedString,
            "userIdNav" : dictForUser,
            "timeTypeNav" : dictForTimeType
        ]
        self.showLoadingIndicator = true
        self.postAbsenceDataCall.postAbsencesData(for: dataDict, idpPayload: idpPayload ?? GetIDPPayload(), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.showLoadingIndicator = false
            case .successData(value: let value):
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: value, options : .allowFragments) as? Dictionary<String, Any>
                    {
                        print(jsonObj)
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            case .success( _, let message):
                print(message as Any)
                self.showLoadingIndicator = false
            }
        })
        
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    init(milliseconds:Int64) {
         self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
     }
}

extension AbsencesViewController {
    func loadOfflineStores() {
        self.allocationHourPersistence.load { [weak self] in
        }
    }
}
