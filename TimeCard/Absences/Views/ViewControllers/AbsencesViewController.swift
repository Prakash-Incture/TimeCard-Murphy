//
//  AbsencesViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class AbsencesViewController: BaseViewController {
    
    var datePickerView =  UIDatePicker()
    var hoursPickerView =  UIPickerView()
    @IBOutlet weak var tableView: UITableView!
    var textField:UITextField?
    
    
    var currentHeaderCells: [CellModelForAbsence] = AbsenceCurrentPage.absenceRecording.getCurrentPageHeaders()
    var allocationDataViewModel:AllocationDataViewModel!
    var absenceData = Absence()
    var hour:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Absences"
        self.customNavigationType = .navWithBack
        absenceData.availableLeaves = UserDefaults.standard.value(forKey: "Emp_Leave_Balnce") as? String
        setupTableViewConfigur()
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addAbsenceData"), object:self.absenceData)
        self.navigationController?.popViewController(animated: true)
    }
}
extension AbsencesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentHeaderCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let cellModel = currentHeaderCells[indexPath.row]
        cell.contentLbl.text = cellModel.absenceModelIdentifier.rawValue
        cell.selectionStyle = .none
        switch cellModel.absenceModelIdentifier {
        case .timeType:
            cell.cellTextField.text =  absenceData.timeType
            cell.cellTextField.addTarget(self, action: #selector(absenceLookUpNavigating), for: .editingDidBegin)
            cell.cellTextField.resignFirstResponder()
            break
            case .availableBalance:
                cell.accessoryType = .none
                cell.cellTextField.isUserInteractionEnabled = false
                cell.cellTextField.text = UserDefaults.standard.value(forKey: "Emp_Leave_Balnce") as? String
            break
            case .startDate:
                cell.cellTextField.text =  absenceData.startDate
                textField?.tag = 1
                self.setDatePickerView(textField: cell.cellTextField)
            break
            case .endDate:
                cell.cellTextField.isHidden = false
                cell.cellTextField.text =  absenceData.endDate
                self.setDatePickerView(textField: cell.cellTextField)
            break
        case .requesting:
            cell.cellTextField.text =  absenceData.requesting ?? "Days/Hours"
            self.seytPickerViews(textField:cell.cellTextField)
            break

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellModel = currentHeaderCells[indexPath.row]
//
//        switch cellModel.absenceModelIdentifier {
//        case .timeType:
//            guard let listVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else { return }
//            listVC.list = cellModel.absenceModelIdentifier.dataForSelection
//            listVC.delegate = self
//            listVC.absenseData = self.allocationDataViewModel?.timeTypeLookUpdata?.availableTimeType?.availableTimeType
//            listVC.sendData = {
//            }
//            self.navigationController?.pushViewController(listVC, animated: true)
//            break
//        case .availableBalance:
//            break
//        case .startDate:
//            self.hoursPickerView.isHidden = true
//            self.datePickerView.isHidden = false
//            break
//        case .endDate:
//            self.hoursPickerView.isHidden = true
//            self.datePickerView.isHidden = false
//            break
//        case .requesting:
//            self.hoursPickerView.isHidden = false
//            self.datePickerView.isHidden = true
//
//            break
//        }
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
    
    func updateValue(value: String?) {
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
        listVC.absenseData = self.allocationDataViewModel?.timeTypeLookUpdata?.availableTimeType?.availableTimeType
        self.navigationController?.pushViewController(listVC, animated: true)
        self.view.endEditing(true)
        return
    }
    func setDatePickerView(textField:UITextField){
        let toolBar = UIToolbar();
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(named: "02265A")
        toolBar.sizeToFit()
        datePickerView.datePickerMode = .date
        textField.inputView = datePickerView
        textField.inputAccessoryView  = toolBar
        self.textField = textField
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
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = Date.DateFormat.monthDayYear.rawValue
        if textField?.tag != 1{
            absenceData.startDate = self.datePickerView.date.toDateFormat(.monthDayYear)
        }else{
        absenceData.endDate = self.datePickerView.date.toDateFormat(.monthDayYear)
        }
        self.tableView.reloadData()
        self.view.endEditing(true)
//        if absenceData.availableLeaves != nil || absenceData.startDate != nil || absenceData.endDate != nil,absenceData.requesting != nil || absenceData.timeType != nil{
//            self.customNavigationType = .navWithSaveandCancel
//        }
        
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
}
