//
//  TimeValuationCell.swift
//  TimeCard
//
//  Created by PremKumar on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class TimeValuationCell: UITableViewCell {

    @IBOutlet weak var costCenterLbl: UILabel!
    @IBOutlet weak var bookingdateLbl: UILabel!
    @IBOutlet weak var hoursAndMinutesLbl: UILabel!
    @IBOutlet weak var payTimeNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
