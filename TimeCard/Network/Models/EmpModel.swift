//
//  EmpModel.swift
//  TimeCard
//
//  Created by prakash on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

struct EmpTimeAccountBalance:Codable {
    let EmpTimeAccountBalance : EmployTimeAccountBalanceData?
    enum CodingKeys: String, CodingKey {
        case EmpTimeAccountBalance = "EmpTimeAccountBalance"
    }
}
struct EmployTimeAccountBalanceData:Codable {
    let EmpTimeAccountBalance : EmpDataModel?
    enum CodingKeys: String, CodingKey {
        case EmpTimeAccountBalance = "EmpTimeAccountBalance"
    }
}
struct EmpDataModel:Codable {
    let balance,timeAccountType,timeAccount,userId,timeUnit:String?
    enum CodingKeys: String, CodingKey{
        case balance
        case timeAccountType
        case timeAccount
        case userId
        case timeUnit
    }
}
struct EmpJobModel:Codable{
    let EmpJob : EmpJobData?
}
struct EmpJobData:Codable {
    let EmpJob : EmployeeDetails?
}
struct EmployeeDetails:Codable{
    let holidayCalendarCode : String?
    let workscheduleCode : String?
    var userNav : UserDetails?
    let costCenter : String?
    let standardHours : String?
    let timeRecordingProfileCode : String?
    let managerId : String?
    let workingDaysPerWeek : String?
    let timeRecordingVariant : String?
    var payGrade : String?
}
struct UserDetails:Codable {
    var User : UserDetailsModel?
}
struct UserDetailsModel:Codable {
    var division : String?
    var defaultFullName : String?
    var firstName : String?
    var lastName : String?
    var jobCode : String?
    var title : String?
    var department : String?
    var userId : String?
    var email : String?
}
struct HolidayAssignment:Codable {
    let holidayAssignment:HolidayAssignmentdata?
    enum CodingKeys: String, CodingKey {
        case holidayAssignment = "HolidayAssignment"
    }

}
struct HolidayAssignmentdata:Codable {
    let holidayDataAssignment:[Holiday]?
    enum CodingKeys: String, CodingKey {
          case holidayDataAssignment = "HolidayAssignment"
      }
}
struct Holiday:Codable{
    let date : String?
    let mdfSystemObjectType : String?
    let lastModifiedDateTime : String?
    let lastModifiedDate : String?
    let mdfSystemEffectiveEndDate : String?
    let lastModifiedBy : String?
    let createdDateTime : String?
    let mdfSystemVersionId : String?
    let lastModifiedDateWithTZ : String?
    let mdfSystemRecordStatus : String?
    let holiday : String?
    let mdfSystemTransactionSequence : String?
    let holidayCalendar_externalCode : String?
    let mdfSystemEffectiveStartDate : String?
    let holidayClass : String?
    let createdDate : String?
    let mdfSystemStatus : String?
    let createdBy : String?
    let mdfSystemEntityId : String?
    let mdfSystemRecordId : String?
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case mdfSystemObjectType = "mdfSystemObjectType"
        case lastModifiedDateTime = "lastModifiedDateTime"
        case lastModifiedDate = "lastModifiedDate"
        case mdfSystemEffectiveEndDate = "mdfSystemEffectiveEndDate"
        case lastModifiedBy = "lastModifiedBy"
        case createdDateTime = "createdDateTime"
        case mdfSystemVersionId = "mdfSystemVersionId"
        case lastModifiedDateWithTZ = "lastModifiedDateWithTZ"
        case mdfSystemRecordStatus = "mdfSystemRecordStatus"
        case holiday = "holiday"
        case mdfSystemTransactionSequence = "mdfSystemTransactionSequence"
        case holidayCalendar_externalCode = "HolidayCalendar_externalCode"
        case mdfSystemEffectiveStartDate = "mdfSystemEffectiveStartDate"
        case holidayClass = "holidayClass"
        case createdDate = "createdDate"
        case mdfSystemStatus = "mdfSystemStatus"
        case createdBy = "createdBy"
        case mdfSystemEntityId = "mdfSystemEntityId"
        case mdfSystemRecordId = "mdfSystemRecordId"
    }
}

struct CostCenterData:Codable {
    var cust_WBS_Element_Test : CostCenterDetailData?
    enum CodingKeys: String, CodingKey {
        case cust_WBS_Element_Test = "cust_WBS_Element_Test"
    }
}
struct CostCenterDetailData:Codable {
    var cust_WBS_Element_Test : [CostCenterDataModel]?
    enum CodingKeys: String, CodingKey {
        case cust_WBS_Element_Test = "cust_WBS_Element_Test"
    }
}
struct CostCenterDataModel:Codable {
    var cust_Costcenter : String?
    var cust_WBS_Owner : String?
    var externalName : String?
    enum CodingKeys: String, CodingKey {
        case cust_Costcenter = "cust_Costcenter"
        case cust_WBS_Owner = "cust_WBS_Owner"
        case externalName = "externalName"
    }
}

struct WorkScheduleModel:Codable{
    var WorkScheduleDay : WorkScheduleDataModel?
    enum CodingKeys: String, CodingKey {
        case WorkScheduleDay = "WorkScheduleDay"
    }
}
struct WorkScheduleDataModel:Codable{
    var WorkScheduleDay : [WorkScheduleDetailDataModel]?
    enum CodingKeys: String, CodingKey {
        case WorkScheduleDay = "WorkScheduleDay"
    }
}
struct WorkScheduleDetailDataModel:Codable{
    var WorkSchedule_externalCode : String?
    var hoursAndMinutes : String?
    var day : String?
    var workingHours : String?
    enum CodingKeys: String, CodingKey {
        case WorkSchedule_externalCode = "WorkSchedule_externalCode"
        case hoursAndMinutes = "hoursAndMinutes"
        case day = "day"
        case workingHours = "workingHours"
    }
}
struct EmployeeTimeOffDataModel:Codable {
    var EmployeeTime : EmployeeTimeOffModel?
}
struct EmployeeTimeOffModel:Codable {
    var EmployeeTime : EmployeeTimeOffDetailModel?
}
struct EmployeeTimeOffDetailModel:Codable {
    var endDate : String?
    var displayQuantity : String?
    var quantityInDays : String?
    var startDate : String?
    var createdDateTime : String?
    var timeType : String?
    var flexibleRequesting : String?
    var approvalStatus : String?
    var deductionQuantity : String?
    var timeTypeNav : TimeOffTimeType?
}
struct TimeOffTimeType:Codable {
    var TimeType : TimeOffTimeTypeModel?
}
struct TimeOffTimeTypeModel:Codable {
    var category : String?
    var externalName_en_US : String?
}
