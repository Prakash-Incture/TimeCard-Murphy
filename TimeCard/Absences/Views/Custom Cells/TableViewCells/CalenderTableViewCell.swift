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
    @IBOutlet weak var recordedHours: UILabel!
    //    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var plannedHourLbl: UILabel!
    
    
    var panGesture = UIPanGestureRecognizer(target: self, action:(Selector(("handlePanGesture:"))))
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //  formatter.timeZone = TimeZone(secondsFromGMT:Int(5.30))
        return formatter
    }()
    var previousDate:String?
    var today:Date?
    var direction:String?
    var selecedDateValues : ((Int)->())?
    var allocationHourPersistence = AllocationHoursCoreData(modelName: "AllocatedHoursCoreData")
    var datesWithMultipleEvents:NSArray?{
        didSet{
            self.calenderView.reloadData()
        }
    }
    var tagVal:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.calenderSetUP()
        self.showDate()
    }
    
    func calenderSetUP(){
        calenderView.scope = .week
        calenderView.appearance.headerMinimumDissolvedAlpha = 0.0
        calenderView.calendarHeaderView.isHidden = true
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.scrollEnabled = false
        calenderView.addGestureRecognizer(panGesture)
        
        calenderView.select(Date().getUTCFormatDate())
        self.loadOfflineStores()
        DataSingleton.shared.selectedDate = calenderView.selectedDate as NSDate?
        
        calenderView.scrollEnabled = false
        dateSelected()
    }
    
    func showDate(){
        let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        
        let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: 0, to:Date(), options: [])
        let first_Date = gregorianCalendar?.fs_firstDay(ofWeek: nextPage!)
        let last_Date = gregorianCalendar?.fs_lastDay(ofWeek: nextPage!)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let max_Date = formatter.string(from: last_Date!)
        let min_Date = formatter.string(from: first_Date!)
        self.datelabel.text = min_Date + " - " + max_Date
        DataSingleton.shared.dateText = self.datelabel.text

        DataSingleton.shared.selectedWeekDates = [(first_Date ?? Date()), last_Date ?? Date()]
        // Show corresponding allocations
        dateSelected()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func leftButtonAction(_ sender: UIButton) {
        let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        var currentPage = calenderView.currentPage.addingTimeInterval(172800.0)
        if sender.tag == 0{
            //currentPage = self.calenderView.currentPage.addingTimeInterval(-172800.0)
            sender.tag = 1
            tagVal = sender.tag
        }
        let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: -1, to: currentPage, options: [])
        calenderView.setCurrentPage(nextPage!, animated: true)
        
        let minDate = gregorianCalendar?.fs_firstDay(ofWeek: nextPage! )?.addingTimeInterval(-172800.0)
        let maxDate = gregorianCalendar?.fs_lastDay(ofWeek: nextPage! )?.addingTimeInterval(-172800.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let max_Date = formatter.string(from: maxDate!)
        let min_Date = formatter.string(from: minDate!)
        self.datelabel.text = min_Date + " - " + max_Date
        DataSingleton.shared.dateText = self.datelabel.text

        DataSingleton.shared.selectedWeekDates = [(minDate ?? Date()), maxDate ?? Date()]
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        var currentPage = self.calenderView.currentPage.addingTimeInterval(172800.0)
        if sender.tag == 0{
           currentPage = self.calenderView.currentPage.addingTimeInterval(-172800.0)
           sender.tag = 1
            tagVal = sender.tag
        }
        let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: 1, to: currentPage, options: [])
        calenderView.setCurrentPage(nextPage!, animated: true)
        
        let minDate = gregorianCalendar?.fs_firstDay(ofWeek: nextPage! )?.addingTimeInterval(-172800.0)
        let maxDate = gregorianCalendar?.fs_lastDay(ofWeek: nextPage! )?.addingTimeInterval(-172800.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let max_Date = formatter.string(from: maxDate!)
        let min_Date = formatter.string(from: minDate!)
        self.datelabel.text = min_Date + " - " + max_Date
        DataSingleton.shared.dateText = self.datelabel.text

        DataSingleton.shared.selectedWeekDates = [(minDate ?? Date()), maxDate ?? Date()]
    }
    
    func dayChanges(day: Int) {
        // Default date factor is one. If changes in from day, we can manipulate the start and end date
        if day != 1 {
            let gregorianCalendar = NSCalendar.init(identifier: .gregorian)

//            let currentPage = calenderView.currentPage
//            let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: 0, to: currentPage, options: [])
//            calenderView.setCurrentPage(nextPage!, animated: true)

            let minDate = (gregorianCalendar?.fs_firstDay(ofWeek: self.calenderView.currentPage))!
            let maxDate = gregorianCalendar?.fs_lastDay(ofWeek: self.calenderView.currentPage)
            let mNDate = gregorianCalendar?.date(byAdding: NSCalendar.Unit.day, value: day-8, to: minDate, options: [])
            let mXDate = gregorianCalendar?.date(byAdding: NSCalendar.Unit.day, value: day-8, to: maxDate!, options: [])

            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            let max_Date = formatter.string(from: mXDate! )
            let min_Date = formatter.string(from: mNDate! )

            self.datelabel.text = min_Date + " - " + max_Date
            if tagVal == 0{
            DataSingleton.shared.dateText = self.datelabel.text
            DataSingleton.shared.selectedWeekDates = [(mNDate ?? Date()), mXDate ?? Date()]
            }
           //
        }
    }
    // Fetch offline data
    func dateSelected() {
        
        let dateFrom = (DataSingleton.shared.selectedDate! as Date).getUTCFormatDate()
        
        if let getResult = allocationHourPersistence.fetchAllFrequesntSeraches(with: NSPredicate(format: "date == %@", dateFrom as NSDate)) as? [AllocationOfflineData]{
            for model in getResult{
                let test = self.allocationHourPersistence.unarchive(allocationData: model.allocationModel ?? Data())
                print(test.duration ?? "0:00")
                print(model.date ?? "")
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "onTapOfDate"), object:getResult)
        }
    }
    

}
extension CalenderTableViewCell:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Get the filtered data here
        let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        
        DataSingleton.shared.selectedDate = date.getUTCFormatDate() as NSDate
        let index = calendar.currentPage.days(from: calendar.selectedDate!)
        self.selecedDateValues?(index)
        //Get today's beginning & end
        DispatchQueue.main.async {
            self.dateSelected()
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        let startDate: Date
//        let endDate: Date?
//        if self.calenderView.scope == .week {
//            startDate = self.calenderView.currentPage
//            endDate = self.calenderView.gregorian.date(byAdding: .day, value: 6, to: startDate)
//        } else { // .month
//            let indexPath = self.calenderView.calculator.indexPath(for: self.calenderView.currentPage, scope: .month)
//            startDate = self.calenderView.calculator.monthHead(forSection: (indexPath?.section)!)!
//            endDate = self.calenderView.gregorian.date(byAdding: .day, value: 41, to: startDate)
//        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date as Date? ?? Date())
        if (self.datesWithMultipleEvents?.contains(dateString))! {
            return 3
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter.string(from: date as Date? ?? Date())
        if (self.datesWithMultipleEvents?.contains(key))! {
            return [UIColor.red, appearance.eventDefaultColor, UIColor.black]
        }
        return nil
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.weekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
}

extension CalenderTableViewCell {
    func loadOfflineStores() {
        self.allocationHourPersistence.load { [weak self] in
        }
    }
}
