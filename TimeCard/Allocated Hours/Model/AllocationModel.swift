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
    var uniqueId: Double?
    var status : String?
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
    var startDate,endDate:String?
    var timeTypeId,costCenterId,durationValueInHours,timeType,costCenter: String?
    var uniqueId: Double?
    var status : String?
    var dateStart: Date?
    var dateEnd: Date?
}
struct UserData: Encodable {
    var userId:String?
    init() {
        self.userId = "6000193"
    }
}
struct TimeAndAbsenceLookUp : Codable {
    var availableTimeType : AvailableTimeType?
}

struct AvailableTimeType : Codable {
    var availableTimeType : [AvailableTimeData]?
}
struct AvailableTimeData:Codable {
    var timeTypeNav:TimeTypeNav?
    var enabledInEssScenario : String?
}


enum MyValues: Codable {
    case string(String)
    case innerItem(TimeAccountPostingRules)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(TimeAccountPostingRules.self) {
            self = .innerItem(x)
            return
        }
        throw DecodingError.typeMismatch(MyValues.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .innerItem(let x):
            try container.encode(x)
        }
    }
}





struct TimeAccountPostingRules:Codable {
    var TimeAccountPostingRule : TimeAccountPostingRuleData?
}
struct TimeAccountPostingRuleData:Codable {
    var timeAccountType : String?
    var TimeType_externalCode : String?
}
struct TimeTypeNav : Codable {
    var timeType : TimeType?
}
struct TimeType : Codable {
    var category : String?
    var timeAccountPostingRules : TimeAccountPostingRules?
    var externalName_en_US : String?
    var externalCode : String?
}
class DataSingleton:NSObject{
    static let shared = DataSingleton()
    var selectedDate:NSDate?
    var selectedWeekDates: [Date]?
    var totalHours:String?
    var plannedHours: Int? = 13*60
    var workingDayPerWeek: Int? = 5
    var dateText:String?
}

struct EmployeeTimeSheetModel:Codable {
    var EmployeeTimeSheet : EmployeeTimeSheetDetailModel?
}
struct EmployeeTimeSheetDetailModel:Codable {
    var EmployeeTimeSheet : EmployeeTimeSheetDetailDataModel?
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
