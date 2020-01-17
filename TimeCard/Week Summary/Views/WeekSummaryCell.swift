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

    var allocationData:AllocaitonData?{
        didSet{
            guard let type = cellType else { return }
            switch type {
            case .total:
                self.titleText.font = self.titleText.font.withSize(20)
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: self.allocationData?.alllocationModel?.first?.duration ?? "", secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
                self.labelData.font = self.titleText.font.withSize(20)
            case .paidAbsences:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: "08:00 ", secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
            case .ot:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: "06:00 ", secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
            case .regularTime:
                self.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: "45:00 ", secondString: "Hours", firstColor: self.titleText.textColor, secondColor: UIColor.lightGray)
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
    
}
