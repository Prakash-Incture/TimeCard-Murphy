//
//  WeekSummaryCell.swift
//  TimeCard
//
//  Created by prakash on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class WeekSummaryCell: UITableViewCell {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var labelData: UILabel!
    
    private var cellModel : CellModel?
    private var cellType: AllocationCellIdentifier?
    var stringHelper = StringColorChnage()
    var totalMins = 0.0
    var absenceHr: Int = 0
    var otHrs: Int = 0
    var totalMinsWorked: Int = 0
    var totalMinWithAbsence = 0.0
    
    var allocationData:AllocaitonData?{
        didSet{
            guard let type = cellType else { return }
            totalMins = Double(DataSingleton.shared.plannedHours ?? 0) * Double(DataSingleton.shared.workingDayPerWeek ?? 0)
            
            if let dataArray = self.allocationData?.weekData{
                absenceHr = 0
                totalMinsWorked = 0
                totalMinWithAbsence = 0.0
                for data in dataArray{
                    if (data.isAbsence ?? false){
                        absenceHr = absenceHr+(data.duration ?? 0)
                        totalMinWithAbsence = totalMins-Double(absenceHr)
                    }else{
                        totalMinsWorked = totalMinsWorked+(data.duration ?? 0)
                        totalMinWithAbsence = totalMins-Double(absenceHr)
                    }
                }
            }
            
            switch type {
            case .total:
                self.titleText.font = self.titleText.font.withSize(20)
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: self.getTotalMins() , secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
                self.labelData.font = self.titleText.font.withSize(20)
                
            case .paidAbsences:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: self.getPaidAbsenceMins(), secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
            case .ot:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: self.getOTMins(), secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
            case .regularTime:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: self.getRegularTime(), secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
            case .status:
                self.labelData.text = "To be Submitted"
                self.labelData.textColor = UIColor.lightGray
            // self.labelData.textColor = UIColor(red:0.98, green:0.86, blue:0.71, alpha:1.0)
            default: return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        
    }
    func setModel(_ cellModel : CellModel) {
        self.cellModel = cellModel
        guard let cellIdentifier = self.cellModel?.cellIdentifier.rawValue else { return }
        self.cellType = AllocationCellIdentifier(rawValue: cellIdentifier)
        self.titleText.text = self.cellType?.getTitleHeader()
        self.accessoryType = cellModel.cellIdentifier.shouldShowIndicator ? .disclosureIndicator : .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // Arithmatic logics for time calculations
    func getOTMins() -> String {
            if totalMinsWorked > Int(totalMinWithAbsence){
                otHrs = totalMinsWorked - Int(totalMinWithAbsence)
            }
        let (hours, min) = Date.minutesToHoursMin(minutes: otHrs)
        return String(format: "%02d:%02d", hours, abs(min))
    }
    
    func getPaidAbsenceMins() -> String {
        let (hours, min) = Date.minutesToHoursMin(minutes: absenceHr)
        return String(format: "%02d:%02d", hours, abs(min))
    }
    
    func getTotalMins() -> String {
        var (hours, min) = Date.minutesToHoursMin(minutes: Int(totalMinWithAbsence))
        hours = hours<0 ? 0 : hours
        min = min<0 ? 0 : min
        return String(format: "%02d:%02d", hours, abs(min))
    }
    
    func getRegularTime() -> String {
        let (hours, min) = Date.minutesToHoursMin(minutes: Int(totalMins))
        return String(format: "%02d:%02d", hours, abs(min))
    }
}
