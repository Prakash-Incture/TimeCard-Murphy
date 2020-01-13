//
//  AllocationModel.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import Foundation

struct AllocaitonData: Codable {
    var alllocationModel:[AllocationModel]?
    var weekData:[WeekSummary]?
    var absence:[Absence]?
    var total,paidAbsences,ot,regularTime,status:String?
}
struct AllocationModel:Codable {
    var timeType,duration,costCneter:String?
}

class AllocatedSingleTon:NSObject{
    static let shared = AllocatedSingleTon()
    var timeType:String?
}
struct WeekSummary:Codable {
    var day,date,hours:String?
}
struct UserData:Codable {
    var userId:String?
    init() {
        self.userId = "vstokes"
    }
}
struct TimeAndAbsenceLookUp : Codable {
    let availableTimeType : AvailableTimeType?
    enum CodingKeys: String, CodingKey {
        case availableTimeType = "AvailableTimeType"
    }
}

struct AvailableTimeType : Codable {
    let availableTimeType : [AvailableTimeData]?
    enum CodingKeys: String, CodingKey {
        case availableTimeType = "AvailableTimeType"
    }
}
struct AvailableTimeData:Codable {
    let timeTypeNav:TimeTypeNav?
    enum CodingKeys: String, CodingKey {
        case timeTypeNav = "timeTypeNav"
    }
}
struct TimeTypeNav : Codable {
    let timeType : TimeType?
    enum CodingKeys: String, CodingKey {
        case timeType = "TimeType"
    }
}
struct TimeType : Codable {
    let category : String?
    let externalName_en_US : String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case externalName_en_US = "externalName_en_US"
  }
}
class DataSingleton:NSObject{
    static let shared = DataSingleton()
    var selectedDate:NSDate?
    var selectedWeekDates: [Date]?
}
