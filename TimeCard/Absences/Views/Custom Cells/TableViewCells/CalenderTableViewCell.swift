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
    @IBOutlet weak var datelabel: UILabel!
    
    var panGesture = UIPanGestureRecognizer(target: self, action:(Selector(("handlePanGesture:"))))
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT:Int(5.30))
        return formatter
    }()
    var previousDate:String?
    var today:Date?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.calenderSetUP()
    }
    func calenderSetUP(){
        calenderView.scope = .week
        calenderView.firstWeekday = 2
        calenderView.appearance.headerMinimumDissolvedAlpha = 0.0
        calenderView.calendarHeaderView.isHidden = true
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.addGestureRecognizer(panGesture)
        self.previousDate = self.dateFormatter.string(from: self.calenderView.currentPage)
        today = Date().startOfWeek
        self.datelabel.text = "\(self.dateFormatter.string(from:self.getCurrentWeekDays()[0])) - \(self.dateFormatter.string(from:self.getCurrentWeekDays()[self.getCurrentWeekDays().count - 1]))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func leftButtonAction(_ sender: Any) {
        let currentDate = self.calenderView.currentPage
        let prevData = Calendar.current.date(byAdding: .day, value: 1, to: currentDate.startOfWeek!)
        self.calenderView.setCurrentPage(prevData ?? Date(), animated: true)

    }
    @IBAction func rightButtonAction(_ sender: Any) {
        let currentDate = self.calenderView.currentPage
        let prevData = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
        self.calenderView.setCurrentPage(prevData ?? Date(), animated: true)
    }
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {

    }
}
extension CalenderTableViewCell:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "onTapOfDate"), object:date)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        today = self.getCurrentWeekDays()[self.getCurrentWeekDays().count - 1]
        self.datelabel.text = "\(self.dateFormatter.string(from:self.getCurrentWeekDays()[0])) - \(self.dateFormatter.string(from:self.getCurrentWeekDays()[self.getCurrentWeekDays().count - 1]))"
    }
    func getCurrentWeekDays() -> [Date]{
        var days:[Date] = []
        for dateIndex in 0..<7 {
            guard let startWeek = today else { return [Date()]}
                   let date = Calendar.current.date(byAdding: .day, value: dateIndex + 1, to: startWeek)
                      days.append(date ?? Date())
               }
           return days
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.weekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
}
