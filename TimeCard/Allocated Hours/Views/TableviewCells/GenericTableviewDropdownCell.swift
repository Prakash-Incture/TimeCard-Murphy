//
//  GenericTableviewDropdownCellTableViewCell.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import UIKit


class GenericTableviewDropdownCell: UITableViewCell,UITextFieldDelegate {
      @IBOutlet weak var cellTextField: UITextField!
      @IBOutlet weak var descriptionLabel: UILabel!
    

      var hour:Int = 1
      var minutes:Int = 0
      var picker = UIPickerView()
    
      private var cellModel : CellModel?
      private var cellType: AllocationCellIdentifier?
      var parent:UIViewController?
      var allocationViewModel:AllocationDataViewModel?
    var weekData: WeekSummary?
      var allocationData:AllocationModel?{
        didSet{
            guard let type = cellType else { return }
            switch type {
            case .timeType:
                self.cellTextField.text = self.allocationData?.timeType ?? ""
            case .duration:
                self.cellTextField.text = self.allocationData?.duration ?? ""
                self.cellTextField.textColor = UIColor(red:0.22, green:0.47, blue:0.80, alpha:1.0)
            case .costCenter:
                self.cellTextField.text = self.allocationData?.costCneter ?? ""
            default: return
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTextField.delegate = self
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "addAllocatedDataToArray"), object: nil, queue: nil) { notification in
            var objectData:[AllocationModel] = notification.object as? [AllocationModel] ?? []
            if self.allocationData?.timeType != "",self.allocationData?.timeType != ""{
              //  objectData.append(self.allocationData!)
                for (index,value) in objectData.enumerated(){
                    if value.timeType == "" || value.duration == ""{
                        objectData.remove(at: index)
                    }
                }
                self.allocationViewModel?.allcationModelData.alllocationModel = objectData
                let tempData = AllocationModel(timeType: "", duration: "", costCneter: "")
                self.allocationViewModel?.allcationModelData.alllocationModel?.append(tempData)
                DispatchQueue.main.async {
                    self.allocationViewModel?.delegate?.didReceiveResponse()
                }
                self.removeObserver()
                return
            }else{
                self.parent?.showAlert(message: "Please fill all the details")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setModel(_ cellModel : CellModel) {
           self.cellModel = cellModel
           guard let cellIdentifier = self.cellModel?.cellIdentifier.rawValue else { return }
           self.cellType = AllocationCellIdentifier(rawValue: cellIdentifier)
           self.descriptionLabel.text = self.cellType?.getTitleHeader()
           self.cellTextField.placeholder = cellType?.getPlaceHoldertext
           self.cellTextField.isUserInteractionEnabled = cellType?.isUserIntractable ?? true
           self.accessoryType = cellModel.cellIdentifier.shouldShowIndicator ? .disclosureIndicator : .none
           self.cellTextField.textColor = cellModel.cellIdentifier.shouldShowIndicator ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .darkGray
           self.descriptionLabel.textColor = cellModel.cellIdentifier.shouldShowIndicator ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .darkGray
       }
}
extension GenericTableviewDropdownCell:UpdateData{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let type = cellType else { return }
        switch type {
        case .timeType:
            guard let detailsVC = UIStoryboard(name: "AllocationHours", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllocationTimeTypeController") as? AllocationTimeTypeController else { return }
            detailsVC.timeType = self.allocationViewModel?.timeTypeLookUpdata?.availableTimeType?.availableTimeType
            detailsVC.allocationData = self.allocationData
            detailsVC.delegate = self
            detailsVC.cellType = self.cellType
            self.parent?.navigationController?.pushViewController(detailsVC, animated: true)
            self.cellTextField.resignFirstResponder()
        case .costCenter:
            guard let detailsVC = UIStoryboard(name: "AllocationHours", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllocationTimeTypeController") as? AllocationTimeTypeController else { return }
            detailsVC.timeType = self.allocationViewModel?.timeTypeLookUpdata?.availableTimeType?.availableTimeType
            detailsVC.allocationData = self.allocationData
            detailsVC.delegate = self
            detailsVC.cellType = self.cellType
            self.parent?.navigationController?.pushViewController(detailsVC, animated: true)
            self.cellTextField.resignFirstResponder()
        case .duration:
            self.showPickerview(textField: self.cellTextField)
        default: break
        }
        
    }
    func uodateMainModel(){
        self.allocationViewModel?.allocationData = self.allocationData
        self.allocationViewModel?.weekData = self.weekData
        
        for (index,value) in (self.allocationViewModel?.allcationModelData.alllocationModel?.enumerated())!{
            if value.timeType == "" || value.duration == "" || value.costCneter == ""{
                self.allocationViewModel?.allcationModelData.alllocationModel?.remove(at: index)
                self.allocationViewModel?.allcationModelData.alllocationModel?.append(self.allocationData!)
            }
        }
        
        for (index, value) in ((self.allocationViewModel?.allcationModelData.weekData?.enumerated())!) {
            if value.dateW == nil || value.dayW == "" || value.hoursW == nil{
                self.allocationViewModel?.allcationModelData.weekData?.remove(at: index)
                self.allocationViewModel?.allcationModelData.weekData?.append(self.weekData!)
            }
        }
    }
    func updateValue(value:String?) {
        guard let type = cellType else { return }
        switch type {
        case .timeType:
            self.allocationData?.timeType = value ?? ""
        case .costCenter:
            self.allocationData?.costCneter = value ?? ""
        case .duration:
            self.allocationData?.duration = value ?? ""
        default: break
        }
        self.uodateMainModel()
    }
    //TODO:
    func updateWeekData() {
        
    }
}
//Picker view Delagetse
extension GenericTableviewDropdownCell:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60

        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row + 1) Hour"
        case 1:
            return "\(row) Minute"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row + 1
        case 1:
            minutes = row
       
        default:
            break;
        }
    }
//Picker View Methods
    func showPickerview(textField : UITextField) {
           cellTextField.placeholder = "--Select--"
           cellTextField.backgroundColor = .clear
           
           //ToolBar
           let toolBar = UIToolbar();
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           
           toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
           toolBar.isTranslucent = true
           toolBar.barTintColor = UIColor(named: "02265A")
           toolBar.sizeToFit()
        
           picker.dataSource = self
           picker.delegate = self
           cellTextField.inputView = picker
           cellTextField.inputAccessoryView = toolBar
           
       }
       
       @objc func donedatePicker(){
           guard let type = cellType else { return }
           switch type {
           case .duration:
            self.updateValue(value:"\(hour) Hour \(minutes) Minutes")
           default:return
           }
           self.endEditing(true)
       }
       
       @objc func cancelDatePicker(){
           self.cellTextField.text = ""
           self.endEditing(true)
       }
    func removeObserver(){
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAllocatedDataToArray"), object: nil)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addingTimeType"), object: nil)
    }
}
