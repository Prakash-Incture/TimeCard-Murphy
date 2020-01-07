//
//  CalenderTableViewCell.swift
//  TimeCard
//
//  Created by prakash on 07/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import FSCalendar

class CalenderTableViewCell: UITableViewCell {
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var leftButtonAction: UIButton!
    @IBOutlet weak var rightAction: UIButton!
    var panGesture = UIPanGestureRecognizer(target: self, action:(Selector(("handlePanGesture:"))))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        calenderView.scope = .week
        calenderView.appearance.headerMinimumDissolvedAlpha = 0.0
        calenderView.appearance.headerDateFormat = "MMM yyyy"
        calenderView.calendarHeaderView.isHidden = true
        calenderView.delegate = self
        calenderView.addGestureRecognizer(panGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func leftButtonAction(_ sender: Any) {
        self.calenderView.currentPage = .distantFuture
        self.calenderView.reloadData()
    }
    @IBAction func rightButtonAction(_ sender: Any) {
        self.calenderView.currentPage = .distantPast
        self.calenderView.reloadData()

    }
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {

    }
}
extension CalenderTableViewCell:FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "onTapOfDate"), object:date)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
}
