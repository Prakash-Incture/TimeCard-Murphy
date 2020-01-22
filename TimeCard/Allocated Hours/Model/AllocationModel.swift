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
    var timeType,duration,costCneter,timeTypeId,costCenterId,durationValueInHours:String?
    var durationMin: Int?
    var selectedDate: Date?
}

class AllocatedSingleTon:NSObject{
    static let shared = AllocatedSingleTon()
    var timeType:String?
}
struct WeekSummary:Codable {
    var day,date,hours:String?
    var duration: Int?
    var selectedDate: Date?
    var isAbsence: Bool?
}
struct UserData: Encodable {
    var userId:String?
    init() {
        self.userId = "6000193"
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
    let externalCode : String?
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case externalName_en_US = "externalName_en_US"
        case externalCode = "externalCode"
  }
}
class DataSingleton:NSObject{
    static let shared = DataSingleton()
    var selectedDate:NSDate?
    var selectedWeekDates: [Date]?
    var totalHours:String?
    var plannedHours: Int? = 13*60
    var workingDayPerWeek: Int? = 5
}

struct EmployeeTimeSheetModel:Codable {
    var EmployeeTimeSheet : EmployeeTimeSheetDetailModel?
}
struct EmployeeTimeSheetDetailModel:Codable {
    var EmployeeTimeSheet : [EmployeeTimeSheetDetailDataModel]?
}
struct EmployeeTimeSheetDetailDataModel:Codable {
    var period : String?
    var recordedHoursAndMinutes : String?
    var endDate : String?
    var employeeTimeSheetEntry : EmployeeTimeSheetEntryModel?
    var comment : String?
    var workflowRequestId : String?
    var workflowAction : String?
    var plannedHoursAndMinutes : String?
    var approvalStatusNav : ApprovalStatusNav?
    var absencesExist : String?
    var startDate : String?
}
struct EmployeeTimeSheetEntryModel:Codable {
    var EmployeeTimeSheetEntry: [EmployeeTimeSheetEntryDataModel]?
}
struct EmployeeTimeSheetEntryDataModel:Codable {
    var quantityInHours: String?
    var costCenter: String?
    var quantityInHoursAndMinutes: String?
    var timeTypeName: String?
    var startDate: String?
}
struct ApprovalStatusNav:Codable {
    var MDFEnumValue : ApprovalStatusNavDeatailModel?
}
struct ApprovalStatusNavDeatailModel:Codable {
    var en_US : String?
}
