//
//  EmpModel.swift
//  TimeCard
//
//  Created by prakash on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

struct EmpTimeAccountBalance:Codable {
    let empTimeAccountBalance : EmployTimeAccountBalanceData?
    enum CodingKeys: String, CodingKey {
        case empTimeAccountBalance = "EmpTimeAccountBalance"
    }
}
struct EmployTimeAccountBalanceData:Codable {
    let empTimeAccountBalanceData : EmpDataModel?
    enum CodingKeys: String, CodingKey {
        case empTimeAccountBalanceData = "EmpTimeAccountBalance"
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
    let empJob : EmpJob?
    enum CodingKeys: String, CodingKey {
        case empJob = "EmpJob"
    }
}
struct EmpJob:Codable {
    let employeeJob : EmployeeDetails?
    enum CodingKeys: String, CodingKey {
        case employeeJob = "EmpJob"
    }
}
struct EmployeeDetails:Codable{
    let occupationalLevels : String?
    let workscheduleCode : String?
    let businessUnit : String?
    let lastModifiedDateTime : String?
    let notes : String?
    let fgtsOptant : String?
    let commitmentIndicator : String?
    let endDate : String?
    let harmfulAgentExposure : String?
    let contractType : String?
    let mandatoryWorkBreakRecord : String?
    let jobTitle : String?
    let sickPaySupplement : String?
    let createdDateTime : String?
    let jobCode : String?
    let electoralCollegeForWorksCouncil : String?
    let validFrom : String?
    let integrationAgent : String?
    let fgtsDate : String?
    let payScaleLevel : String?
    let division : String?
    let timeTypeProfileCode : String?
    let eeoClass : String?
    let familyRelationshipWithEmployer : String?
    let hazard : String?
    let exchangeRate : String?
    let fromCurrency : String?
    let internshipLevel : String?
    let eeo5JobCategory : String?
    let flsaStatus : String?
    let holidayCalendarCode : String?
    let empRelationship : String?
    let educationalEntity : String?
    let permitIndicator : String?
    let costCenter : String?
    let standardHours : String?
    let residentVote : String?
    let timeRecordingProfileCode : String?
    let electoralCollegeForWorkersRepresentatives : String?
    let laborProtection : String?
    let eeo4JobCategory : String?
    let eventReason : String?
    let isCompetitionClauseActive : String?
    let internshipSchool : String?
    let assedicCertInitialStateNum : String?
    let includedChallengedPersonQuota : String?
    let fgtsPercent : String?
    let toCurrency : String?
    let position : String?
    let startDate : String?
    let payScaleArea : String?
    let exclExecutiveSector : String?
    let isFulltimeEmployee : String?
    let emplStatus : String?
    let probationPeriodEndDate : String?
    let payScaleType : String?
    let timezone : String?
    let workingDaysPerWeek : String?
    let countryOfCompany : String?
    let expectedReturnDate : String?
    let regularTemp : String?
    let eeo6JobCategory : String?
    let createdOn : String?
    let municipalInseeCode : String?
    let pcfm : String?
    let healthRisk : String?
    let workLocation : String?
    let contractReferenceForAed : String?
    let timeRecordingAdmissibilityCode : String?
    let isSideLineJobAllowed : String?
    let fte : String?
    let payGrade : String?
    let travelDistance : String?
    let company : String?
    let retired : String?
    let event : String?
    let department : String?
    let eeo1JobCategory : String?
    let timeRecordingVariant : String?
    let employeeClass : String?
    let employmentType : String?
    let assedicCertObjectNum : String?
    let lastModifiedBy : String?
    let managerId : String?
    let userId : String?
    let lastModifiedOn : String?
    let payScaleGroup : String?
    let mandatoryInternship : String?
    let employeeWorkgroupMembership : String?
    let positionEntryDate : String?
    let dynamicBreakConfigCode : String?
    let createdBy : String?
    let workerCategory : String?
    let defaultOvertimeCompensationVariant : String?
    let seqNumber : String?
    let location : String?

    enum CodingKeys: String, CodingKey {

        case occupationalLevels = "occupationalLevels"
        case workscheduleCode = "workscheduleCode"
        case businessUnit = "businessUnit"
        case lastModifiedDateTime = "lastModifiedDateTime"
        case notes = "notes"
        case fgtsOptant = "fgtsOptant"
        case commitmentIndicator = "commitmentIndicator"
        case endDate = "endDate"
        case harmfulAgentExposure = "harmfulAgentExposure"
        case contractType = "contractType"
        case mandatoryWorkBreakRecord = "mandatoryWorkBreakRecord"
        case jobTitle = "jobTitle"
        case sickPaySupplement = "sickPaySupplement"
        case createdDateTime = "createdDateTime"
        case jobCode = "jobCode"
        case electoralCollegeForWorksCouncil = "electoralCollegeForWorksCouncil"
        case validFrom = "validFrom"
        case integrationAgent = "integrationAgent"
        case fgtsDate = "fgtsDate"
        case payScaleLevel = "payScaleLevel"
        case division = "division"
        case timeTypeProfileCode = "timeTypeProfileCode"
        case eeoClass = "eeoClass"
        case familyRelationshipWithEmployer = "familyRelationshipWithEmployer"
        case hazard = "hazard"
        case exchangeRate = "exchangeRate"
        case fromCurrency = "fromCurrency"
        case internshipLevel = "internshipLevel"
        case eeo5JobCategory = "eeo5JobCategory"
        case flsaStatus = "flsaStatus"
        case holidayCalendarCode = "holidayCalendarCode"
        case empRelationship = "empRelationship"
        case educationalEntity = "educationalEntity"
        case permitIndicator = "permitIndicator"
        case costCenter = "costCenter"
        case standardHours = "standardHours"
        case residentVote = "residentVote"
        case timeRecordingProfileCode = "timeRecordingProfileCode"
        case electoralCollegeForWorkersRepresentatives = "electoralCollegeForWorkersRepresentatives"
        case laborProtection = "laborProtection"
        case eeo4JobCategory = "eeo4JobCategory"
        case eventReason = "eventReason"
        case isCompetitionClauseActive = "isCompetitionClauseActive"
        case internshipSchool = "internshipSchool"
        case assedicCertInitialStateNum = "assedicCertInitialStateNum"
        case includedChallengedPersonQuota = "includedChallengedPersonQuota"
        case fgtsPercent = "fgtsPercent"
        case toCurrency = "toCurrency"
        case position = "position"
        case startDate = "startDate"
        case payScaleArea = "payScaleArea"
        case exclExecutiveSector = "exclExecutiveSector"
        case isFulltimeEmployee = "isFulltimeEmployee"
        case emplStatus = "emplStatus"
        case probationPeriodEndDate = "probationPeriodEndDate"
        case payScaleType = "payScaleType"
        case timezone = "timezone"
        case workingDaysPerWeek = "workingDaysPerWeek"
        case countryOfCompany = "countryOfCompany"
        case expectedReturnDate = "expectedReturnDate"
        case regularTemp = "regularTemp"
        case eeo6JobCategory = "eeo6JobCategory"
        case createdOn = "createdOn"
        case municipalInseeCode = "municipalInseeCode"
        case pcfm = "pcfm"
        case healthRisk = "healthRisk"
        case workLocation = "workLocation"
        case contractReferenceForAed = "contractReferenceForAed"
        case timeRecordingAdmissibilityCode = "timeRecordingAdmissibilityCode"
        case isSideLineJobAllowed = "isSideLineJobAllowed"
        case fte = "fte"
        case payGrade = "payGrade"
        case travelDistance = "travelDistance"
        case company = "company"
        case retired = "retired"
        case event = "event"
        case department = "department"
        case eeo1JobCategory = "eeo1JobCategory"
        case timeRecordingVariant = "timeRecordingVariant"
        case employeeClass = "employeeClass"
        case employmentType = "employmentType"
        case assedicCertObjectNum = "assedicCertObjectNum"
        case lastModifiedBy = "lastModifiedBy"
        case managerId = "managerId"
        case userId = "userId"
        case lastModifiedOn = "lastModifiedOn"
        case payScaleGroup = "payScaleGroup"
        case mandatoryInternship = "mandatoryInternship"
        case employeeWorkgroupMembership = "employeeWorkgroupMembership"
        case positionEntryDate = "positionEntryDate"
        case dynamicBreakConfigCode = "dynamicBreakConfigCode"
        case createdBy = "createdBy"
        case workerCategory = "workerCategory"
        case defaultOvertimeCompensationVariant = "defaultOvertimeCompensationVariant"
        case seqNumber = "seqNumber"
        case location = "location"
    }
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
