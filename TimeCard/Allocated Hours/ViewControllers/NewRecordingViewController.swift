//
//  ViewController.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import UIKit
import SAPFiori
import CoreData

// Coredata protocol
protocol CoreDataProtocol {
    init(modelName: String)
    var persistantContainer: NSPersistentContainer { get set }
    var viewContext: NSManagedObjectContext { get }
    var isSyncInprogress: Bool { get set }
    func saveRequest(_ request: URLRequest, for purpose: String?)
    func removePreviousData(fetchRequest: NSFetchRequest<NSFetchRequestResult>, predicate: NSPredicate?)
}

extension CoreDataProtocol {
    var viewContext: NSManagedObjectContext {
        return self.persistantContainer.viewContext
    }
    
    func saveChanges() {
        try? self.viewContext.save()
    }
    
    func removeOldData<managedObject: NSManagedObject>(object: managedObject) {
        self.viewContext.delete(object)
        try? self.viewContext.save()
    }
}

class NewRecordingViewController: BaseViewController, SAPFioriLoadingIndicator{
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var loadingIndicator: FUILoadingIndicatorView?
    var currentPage: CurrentPage = CurrentPage.newRecording
    var currentHeaderCells: [[CellModel]] = CurrentPage.newRecording.getCurrentPageHeaders()
    var allocationDataViewModel:AllocationDataViewModel?
    lazy var postTimeSheetDataCall = RequestManager<ApproveListModels>()

    var showLoadingIndicator: Bool? {
        didSet {
            if showLoadingIndicator == true {
                self.showFioriLoadingIndicator("Loding")
            } else {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    var allocationHourPersistence = AllocationHoursCoreData(modelName: "AllocatedHoursCoreData")
    var allocationModel: AllocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.customNavigationType = .navWithSaveandCancel
        self.loadOfflineStores()
        self.setupTableView()
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        self.allocationDataViewModel = AllocationDataViewModel(delegate: self)
        self.allocationDataViewModel?.dataFetching()
        if self.allocationDataViewModel?.allcationModelData.absence == nil{
            self.allocationDataViewModel?.allcationModelData.absence = []
            self.allocationDataViewModel?.allcationModelData.absence?.append(Absence())
        }
        DispatchQueue.main.async {
            self.getAbsenceOfflineData()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.allocationDataViewModel?.delegate = self
        
    }
    
    override func selectedCancel(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "GenericTableviewDropdownCell", bundle: nil), forCellReuseIdentifier: "GenericTableviewDropdownCell")
        self.tableView.register(UINib(nibName: "AllocatedTimeTableCell", bundle: nil), forCellReuseIdentifier: "AllocatedTimeTableCell")
        self.tableView.register(UINib(nibName: "WeekSummaryCell", bundle: nil), forCellReuseIdentifier: "WeekSummaryCell")
    }
    
    override func selectedSave(sender: UIButton) {
        if let newRec = self.allocationDataViewModel?.allcationModelData.alllocationModel?.last{
            if newRec.costCneter != "" && newRec.duration != "" && newRec.timeType != "" {
                if newRec.uniqueId == nil{
                     //Get today's beginning & end
                     let dateFrom = (DataSingleton.shared.selectedDate! as Date).getUTCFormatDate()
                     if let newHours = self.allocationDataViewModel?.allcationModelData.alllocationModel{
                         for var allocationObj in newHours {
                             allocationObj.status = "to be submitted"
                             allocationObj.uniqueId = Date().timeIntervalSince1970 // Adding unique id
                            allocationHourPersistence.saveAllocationHour(allocationModel: allocationObj, withDate: dateFrom)
                         }
                     }

                     DispatchQueue.main.async {
                         self.navigationController?.popViewController(animated: true)
                     }
                    // self.postTimeSheetDataAPICall()
                }else{
                    updateOfflineModel(updatedData: newRec)
                }

            }else{
                //TODO:
                // Show error message
                self.showAlert(message: "Please fill all the details")
            }
        }
        
    }
    
    func updateOfflineModel(updatedData: AllocationModel) {
        let dataObj = updatedData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllocationOfflineData")
        let predicate = NSPredicate(format: "date == %@ AND key == %@", (dataObj.selectedDate?.getUTCFormatDate() as NSDate?)!, "Allocation")
        self.allocationHourPersistence.updatePreviousDataWithUniqueId(fetchRequest: fetchRequest, predicate: predicate, uniqueId: updatedData.uniqueId!, updatedObj: updatedData)
        self.navigationController?.popViewController(animated: false)
    }
// Fetch offline data
    func getAbsenceOfflineData() {
        
        let dateFrom = (DataSingleton.shared.selectedDate! as Date).getUTCFormatDate()
        guard let getResult = allocationHourPersistence.fetchAllFrequesntSeraches(with: NSPredicate(format: "date == %@ AND key == %@", dateFrom as NSDate, "Absence")) as? [AllocationOfflineData] else {
            return
        }
        self.allocationDataViewModel?.allcationModelData.absence?.removeAll()
        for model in getResult{
            let absence = self.allocationHourPersistence.unarchiveAbsence(absenceData: model.allocationModel ?? Data())
            
            self.allocationDataViewModel?.allcationModelData.absence?.append(absence ?? Absence())
            self.tableView.reloadData()
            
            for (index,value) in  (self.allocationDataViewModel?.allcationModelData.absence?.enumerated())!{
                if value.timeType == nil {
                    self.allocationDataViewModel?.allcationModelData.absence?.remove(at: index)
                }
            }
            
        }
        self.allocationDataViewModel?.allcationModelData.absence?.append(Absence())

    }
}
//TableView delegates
extension NewRecordingViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.currentHeaderCells[section].count
        }else{
            return self.allocationDataViewModel?.allcationModelData.absence?.count ?? 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cellModel = currentHeaderCells[indexPath.section][indexPath.row] as CellModel
            switch cellModel.reuseIdentifier {
            case .GenericTableviewDropdownCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
                cell.setModel(cellModel)
                cell.selectionStyle = .none
                cell.parent = self
                cell.costcenterData = self.allocationDataViewModel?.costCenterData.cust_WBS_Element_Test?.cust_WBS_Element_Test ?? [CostCenterDataModel]()
                cell.allocationData = self.allocationDataViewModel?.allcationModelData.alllocationModel?[indexPath.row] ?? AllocationModel()
                return cell
            case .AllocatedTimeTableCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? AllocatedTimeTableCell else { fatalError("Textfield cell not found") }
                if let updateModel = self.allocationModel {
                    self.allocationDataViewModel?.allcationModelData.alllocationModel?.removeAll()
                    self.allocationDataViewModel?.allcationModelData.alllocationModel = [updateModel]
                }
                cell.allocationDataArray = self.allocationDataViewModel?.allcationModelData.alllocationModel ?? []
                cell.allocationViewModel = self.allocationDataViewModel
                cell.parent = self
                return cell
            case .WeekSummaryCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? WeekSummaryCell else { fatalError("Textfield cell not found") }
                return cell
            }
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableviewDropdownCell") as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            cell.selectionStyle = .none
            if  ((self.allocationDataViewModel?.allcationModelData.absence?.count ?? 0) - 1) == indexPath.row{
                cell.descriptionLabel.text = "Add Absences"
                cell.accessoryType = .disclosureIndicator
                cell.cellTextField.placeholder = ""
                cell.cellTextField.addTarget(self, action: #selector(absenceLookUpNavigating), for: .editingDidBegin)
            }else{
                let tempData = self.allocationDataViewModel?.allcationModelData.absence?[indexPath.row]
                cell.descriptionLabel.text = tempData?.timeType
                cell.cellTextField.text = ""
                cell.cellTextField.placeholder = ""
                cell.cellTextField.isUserInteractionEnabled = false
                cell.accessoryType = .none
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentPage.titleForHeaderInSection(section: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat((self.allocationDataViewModel?.allcationModelData.alllocationModel?.count ?? 220) * 220)
        }
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     /*   switch indexPath.section {
        case 1:
            let tempData = self.allocationDataViewModel?.allcationModelData.absence?[indexPath.row]
            guard let absenceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbsencesViewController") as? AbsencesViewController else { return }
            absenceVC.allocationDataViewModel = self.allocationDataViewModel
            if tempData?.timeType != nil{
                absenceVC.absenceData = tempData ?? Absence()
            }
            absenceVC.sendBack = {
                self.navigationController?.popViewController(animated: false)
            }
            self.navigationController?.pushViewController(absenceVC, animated: true)
            self.view.endEditing(true)
            break
        default:
            break
        }*/
    }
    
    @objc func allocatedHoursAction(){
        self.tableView.reloadData()
    }
    @objc func absenceLookUpNavigating(){
        guard let absenceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbsencesViewController") as? AbsencesViewController else { return }
        absenceVC.allocationDataViewModel = self.allocationDataViewModel
        self.navigationController?.pushViewController(absenceVC, animated: true)
        self.view.endEditing(true)
        
    }
}
extension NewRecordingViewController: GenericViewModelProtocol {
    func failedWithReason(message: String) {
        //   self.showAlert(message: message)
    }
    func didReceiveResponse() {
        DispatchQueue.main.async {
            self.allocationModel = self.allocationDataViewModel?.allocationData
            self.tableView.reloadData()
        }
    }
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAbsenceData"), object: nil)
    }
}
extension NewRecordingViewController{
    
    func postTimeSheetDataAPICall(){
         let externalCode = Int.random(in: 0...100000000)
        let startDate = (DataSingleton.shared.selectedDate as Date?)!.currentTimeMillis()
         let dataDictForEmployee:[String:Any] = [
            "uri":"ExternalTimeData('\(externalCode)')"
        ]
         let dataDict:[String:Any] = [
             
             "__metadata" : dataDictForEmployee,
             "startDate" : "/Date(\(startDate))/",
             "externalCode" : "\(externalCode)",
            "hours" : self.allocationDataViewModel?.allcationModelData.alllocationModel?.last?.durationValueInHours ?? "",
             "userId" : UserData().userId ?? "",
             "costCenter" : self.allocationDataViewModel?.allcationModelData.alllocationModel?.last?.costCenterId ?? "",
             "timeType" : self.allocationDataViewModel?.allcationModelData.alllocationModel?.last?.timeTypeId ?? ""
         ]
         self.showLoadingIndicator = true
         self.postTimeSheetDataCall.postAbsencesData(for: dataDict, idpPayload: GetIDPPayload(), completion: { [weak self] result in
             guard let self = self else { return }
             switch result {
             case .failure( _):
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

extension NewRecordingViewController {
    func loadOfflineStores() {
        self.allocationHourPersistence.load { [weak self] in
        }
    }
}
