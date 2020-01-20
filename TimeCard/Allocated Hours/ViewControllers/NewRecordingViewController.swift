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
    var allocationDataViewModel:AllocationDataViewModel!
    
    var showLoadingIndicator: Bool? {
        didSet {
            if showLoadingIndicator == true {
                self.showFioriLoadingIndicator("Loding")
            } else {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    var allocationHourPersistence:AllocationHoursCoreData?
    //= AllocationHoursCoreData(modelName: "AllocationOffline")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.customNavigationType = .navWithSaveandCancel
        self.setupViewModel()
        self.setupTableView()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "addAbsenceData"), object: nil, queue: nil) { notification in
            for (index,value) in  (self.allocationDataViewModel.allcationModelData.absence?.enumerated())!{
                if value.timeType == nil {
                    self.allocationDataViewModel.allcationModelData.absence?.remove(at: index)
                    self.allocationDataViewModel.allcationModelData.absence?.append(notification.object as! Absence)
                    self.allocationDataViewModel.allcationModelData.absence?.append(Absence())
                }
            }
            self.removeObservers()
        }
        
    }
    private func setupViewModel() {
        self.allocationDataViewModel = AllocationDataViewModel(delegate: self)
        self.allocationDataViewModel?.dataFetching()
        self.allocationDataViewModel.empTimeOffBalanceAPICalling()
        if self.allocationDataViewModel.allcationModelData.absence == nil{
            self.allocationDataViewModel.allcationModelData.absence = []
            self.allocationDataViewModel.allcationModelData.absence?.append(Absence())
        }
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
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
        if let newRec = self.allocationDataViewModel.allcationModelData.alllocationModel?.last{
            if newRec.costCneter != "" && newRec.duration != "" && newRec.timeType != "" {
                //Get today's beginning & end
                var currentCalender = Calendar.current
                currentCalender.timeZone = TimeZone(identifier: "UTC")! //UTC
                let dateFrom = currentCalender.startOfDay(for: DataSingleton.shared.selectedDate! as Date) // eg. 2016-10-10
                        if let newHours = self.allocationDataViewModel.allcationModelData.alllocationModel{
                            for allocationObj in newHours {
                                allocationHourPersistence?.saveAllocationHour(allocationModel: allocationObj, withDate: dateFrom)
                            }
                        }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                //TODO:
                // Show error message
                self.showAlert(message: "Please fill all the details")
            }
        }

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
            return self.allocationDataViewModel.allcationModelData.absence?.count ?? 1
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
                cell.costcenterData = self.allocationDataViewModel.costCenterData.cust_WBS_Element_Test?.cust_WBS_Element_Test ?? [CostCenterDataModel]()
                cell.allocationData = self.allocationDataViewModel.allcationModelData.alllocationModel?[indexPath.row] ?? AllocationModel()
                return cell
            case .AllocatedTimeTableCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? AllocatedTimeTableCell else { fatalError("Textfield cell not found") }
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
            if  ((self.allocationDataViewModel.allcationModelData.absence?.count ?? 0) - 1) == indexPath.row{
                cell.descriptionLabel.text = "Add Absences"
                cell.accessoryType = .disclosureIndicator
                cell.cellTextField.addTarget(self, action: #selector(absenceLookUpNavigating), for: .editingDidBegin)
            }else{
                let tempData = self.allocationDataViewModel.allcationModelData.absence?[indexPath.row]
                cell.descriptionLabel.text = tempData?.timeType
                cell.cellTextField.text = ""
                cell.cellTextField.placeholder = ""
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
            return CGFloat((self.allocationDataViewModel.allcationModelData.alllocationModel?.count ?? 220) * 220)
        }
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let tempData = self.allocationDataViewModel.allcationModelData.absence?[indexPath.row]
            guard let absenceVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbsencesViewController") as? AbsencesViewController else { return }
            absenceVC.allocationDataViewModel = self.allocationDataViewModel
            if tempData?.timeType != nil{
                absenceVC.absenceData = tempData ?? Absence()
            }
            self.navigationController?.pushViewController(absenceVC, animated: true)
            self.view.endEditing(true)
            break
        default:
            break
        }
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
            self.tableView.reloadData()
        }
    }
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAbsenceData"), object: nil)
    }
}
