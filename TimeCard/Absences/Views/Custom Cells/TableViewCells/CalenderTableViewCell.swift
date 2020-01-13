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
        formatter.dateFormat = "dd MMM YYYY"
        formatter.timeZone = TimeZone(secondsFromGMT:Int(5.30))
        return formatter
    }()
    var previousDate:String?
    var today:Date?
    var allocationHourPersistence:AllocationHoursCoreData?
    var datesWithMultipleEvents = ["10 Jan 2020", "09 Jan 2020", "08 Jan 2020", "07 Jan 2020"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.calenderSetUP()
    }
    func calenderSetUP(){
        
        calenderView.scope = .week
        calenderView.firstWeekday = 1
        calenderView.appearance.headerMinimumDissolvedAlpha = 0.0
        calenderView.calendarHeaderView.isHidden = true
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.addGestureRecognizer(panGesture)
        calenderView.select(Date())
        DataSingleton.shared.selectedDate = calenderView.selectedDate as NSDate?
        DataSingleton.shared.selectedWeekDates = getCurrentWeekDays()
        self.showDate()
   
    }

    func showDate(){
        let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        let currentPage =  self.calenderView.currentPage
        let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: 1, to: currentPage, options: [])
        let first_Date = gregorianCalendar?.fs_firstDay(ofWeek: nextPage!)
        let last_Date = gregorianCalendar?.fs_lastDay(ofWeek: nextPage!)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let max_Date = formatter.string(from: last_Date!)
        let min_Date = formatter.string(from: first_Date!)
        self.datelabel.text = min_Date + " - " + max_Date
        
        // Show corresponding allocations
        dateSelected()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func leftButtonAction(_ sender: Any) {
      let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
        let currentPage = calenderView.currentPage
        let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: -1, to: currentPage, options: [])
        calenderView.setCurrentPage(nextPage!, animated: true)
        
        let minDate = gregorianCalendar?.fs_firstDay(ofWeek: nextPage! )
        let maxDate = gregorianCalendar?.fs_lastDay(ofWeek: nextPage! )
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let max_Date = formatter.string(from: maxDate!)
        let min_Date = formatter.string(from: minDate!)
        self.datelabel.text = min_Date + " - " + max_Date


    }
    @IBAction func rightButtonAction(_ sender: Any) {
           let gregorianCalendar = NSCalendar.init(identifier: .gregorian)
           let currentPage = self.calenderView.currentPage
            let nextPage = gregorianCalendar?.date(byAdding: NSCalendar.Unit.weekOfYear, value: 1, to: currentPage, options: [])
            calenderView.setCurrentPage(nextPage!, animated: true)
            
            let minDate = gregorianCalendar?.fs_firstDay(ofWeek: nextPage! )
            let maxDate = gregorianCalendar?.fs_lastDay(ofWeek: nextPage! )
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            let max_Date = formatter.string(from: maxDate!)
            let min_Date = formatter.string(from: minDate!)
            self.datelabel.text = min_Date + " - " + max_Date
    }
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {

    }
    
    func dateSelected() {
        var currentCalender = Calendar.current
        currentCalender.timeZone = TimeZone(identifier: "UTC")!
        let dateFrom = currentCalender.startOfDay(for: DataSingleton.shared.selectedDate! as Date) // eg. 2016-10-10 00:00:00
        
        if let getResult = allocationHourPersistence?.fetchAllFrequesntSeraches(with: NSPredicate(format: "date == %@", dateFrom as NSDate)) as? [AllocationOfflineData]{
                  for model in getResult{
                        let test = self.allocationHourPersistence?.unarchive(allocationData: model.allocationModel ?? Data())
                      print(test?.duration ?? "0:00")
                      print(model.date ?? "")
                  }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "onTapOfDate"), object:getResult)
              }
    }
}
extension CalenderTableViewCell:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       // Get the filtered data here
        DataSingleton.shared.selectedDate = date as NSDate
        
        //Get today's beginning & end
        dateSelected()
              
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
         
    }
   func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    let dateString = self.dateFormatter.string(from: date as Date? ?? Date())
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
         let key = self.dateFormatter.string(from: date as Date? ?? Date())
         if self.datesWithMultipleEvents.contains(key) {
             return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
         }
         return nil
     }
    func getCurrentWeekDays() -> [Date]{
        var days:[Date] = []
        
//        for dateIndex in 0..<7 {
//            guard let startWeek = today else { return [Date()]}
//                   let date = Calendar.current.date(byAdding: .day, value: dateIndex + 1, to: startWeek)
//                      days.append(date ?? Date())
//               }
        
        days.append(DataSingleton.shared.selectedDate! as Date)
        days.append(Calendar.current.date(byAdding: .day, value: 6, to: DataSingleton.shared.selectedDate! as Date)!)
        
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
