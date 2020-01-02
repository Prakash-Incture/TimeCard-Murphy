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
      var allocationData:AllocationModel?{
        didSet{
            switch cellType {
            case .timeType:
                self.cellTextField.text = self.allocationData?.timeType ?? ""
            case .duration:
                self.cellTextField.text = self.allocationData?.duration ?? ""
            default: return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        picker.dataSource = self
        picker.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setModel(_ cellModel : CellModel) {
           self.cellModel = cellModel
           self.cellTextField.delegate = self
           guard let cellIdentifier = self.cellModel?.cellIdentifier.rawValue else { return }
           self.cellType = AllocationCellIdentifier(rawValue: cellIdentifier)
           self.descriptionLabel.text = self.cellType?.getTitleHeader()
           self.cellTextField.placeholder = cellType?.getPlaceHoldertext
           self.cellTextField.delegate = self
           self.cellTextField.isUserInteractionEnabled = cellType?.isUserIntractable ?? true
           self.accessoryType = cellModel.cellIdentifier.shouldShowIndicator ? .disclosureIndicator : .none
           self.cellTextField.textColor = cellModel.cellIdentifier.shouldShowIndicator ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .darkGray
           self.descriptionLabel.textColor = cellModel.cellIdentifier.shouldShowIndicator ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : .darkGray
       }
}
extension GenericTableviewDropdownCell:UpdateData{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch cellType {
        case .timeType:
            guard let detailsVC = UIStoryboard(name: "AllocationHours", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllocationTimeTypeController") as? AllocationTimeTypeController else { return }
            detailsVC.timeType = cellType
            detailsVC.allocationData = allocationData
            detailsVC.delegate = self
            self.parent?.navigationController?.pushViewController(detailsVC, animated: true)
            self.cellTextField.resignFirstResponder()
        case .duration:
            self.showPickerview(textField: self.cellTextField)
        default: return
        }
        
    }
    func updateValue(value:String?) {
        switch cellType {
        case .timeType:
            self.allocationData?.timeType = value ?? ""
            self.cellTextField.text = value ?? ""
        default: return
        }
    }
}
//Picker view Delagetse
extension GenericTableviewDropdownCell:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
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
           cellTextField.inputView = picker
           cellTextField.inputAccessoryView = toolBar
           
       }
       
       @objc func donedatePicker(){
           guard let type = cellType else { return }
           switch type {
           case .duration:
               self.allocationData?.timeType = "\(hour) Hour \(minutes) Minutes"
               self.cellTextField.text = "\(hour) Hour \(minutes) Minutes"
           default:return
           }
           self.endEditing(true)
       }
       
       @objc func cancelDatePicker(){
           self.cellTextField.text = ""
           self.endEditing(true)
       }
}
