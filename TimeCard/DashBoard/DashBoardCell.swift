//
//  DashBoardCell.swift
//  DFT
//
//  Created by Soumya Singh on 23/01/18.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit

class DashBoardCell: UITableViewCell {

    @IBOutlet var dashBoardImage: UIImageView!
    @IBOutlet var dashBoardLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
}
