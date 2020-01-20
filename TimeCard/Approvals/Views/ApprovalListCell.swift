//
//  ApprovalListCell.swift
//  TimeCard
//
//  Created by PremKumar on 08/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class ApprovalListCell: UITableViewCell {

    @IBOutlet weak var periodTitleLbl: UILabel!
    @IBOutlet weak var planedTitleLbl: UILabel!
    @IBOutlet weak var workingTimeTitleLbel: UILabel!
    @IBOutlet weak var appImgView: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var appPositionLbl: UILabel!
    @IBOutlet weak var periodView: UIView!
    @IBOutlet weak var planedView: UIView!
    @IBOutlet weak var workTimeView: UIView!
    @IBOutlet weak var initiatedView: UIView!
    @IBOutlet weak var initiatedDateView: UIView!
    
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var planedLbl: UILabel!
    @IBOutlet weak var workTimeLbl: UILabel!
    @IBOutlet weak var initiatedLbl: UILabel!
    @IBOutlet weak var initiatedDateLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    var updateUi : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        appImgView.layer.cornerRadius = appImgView.frame.width/2
        appImgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
        self.updateUi?()
        }
    }
    
}
