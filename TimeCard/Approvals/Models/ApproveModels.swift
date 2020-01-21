//
//  ApproveModels.swift
//  TimeCard
//
//  Created by PremKumar on 13/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation



struct ApproveListModels: Codable {
    
}

struct GetIDPPayload: Codable {
//    var client_id: String?
//    var user_id: String?
//    var token_url: String?
//    var private_key: String
//
//    init() {
//        self.client_id = ApproveConstants.clientId
//        self.user_id = ApproveConstants.userId
//        self.token_url = ApproveConstants.tokenUrl
//        self.private_key = ApproveConstants.privatekay
//    }
    
}

struct TimeSheetRequestModel : Codable {
    let d : D?

    enum CodingKeys: String, CodingKey {

        case d = "d"
    }
}

struct __metadata : Codable {
    let uri : String?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case uri = "uri"
        case type = "type"
    }
}

struct D : Codable {
    let results1 : [Results1]?

    enum CodingKeys: String, CodingKey {

        case results1 = "results"
    }
}

struct Entries : Codable {
    let results3 : [Results3]?

    enum CodingKeys: String, CodingKey {

        case results3 = "results"
    }
}

struct Results1 : Codable {
    let __metadata : __metadata?
    let categoryId : String?
    let categoryLabel : String?
    let displayOrder : Int?
    let todos : Todos?

    enum CodingKeys: String, CodingKey {

        case __metadata = "__metadata"
        case categoryId = "categoryId"
        case categoryLabel = "categoryLabel"
        case displayOrder = "displayOrder"
        case todos = "todos"
    }
}

struct Results2 : Codable {
    let categoryId : String?
    let completedDate : String?
    let dueDate : String?
    let dueDateOffSet : Int?
    let entries : Entries?
    let entryId : Int?
    let name : String?
    let status : Int?
    let statusLabel : String?
    let stepDescAlt : String?
    let todoItemId : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case categoryId = "categoryId"
        case completedDate = "completedDate"
        case dueDate = "dueDate"
        case dueDateOffSet = "dueDateOffSet"
        case entries = "entries"
        case entryId = "entryId"
        case name = "name"
        case status = "status"
        case statusLabel = "statusLabel"
        case stepDescAlt = "stepDescAlt"
        case todoItemId = "todoItemId"
        case url = "url"
    }
}

struct Results3 : Codable {
    let completedDate : String?
    let formDataId : String?
    let status : Int?
    let statusLabel : String?
    let subjectFullName : String?
    let subjectId : String?
    let url : String?
    var wfRequestUINav : WfRequestUINav?
    var workflowAllowedActionListNav : workflowAllowedActionListNav?
    var peroid : String?
    var planned : String?
    var timeType : String?
    var approvalStatus : String?
    var isSelected : Bool?
    let wfRequestId : String?
    var createdOn : String?
    var categoryLabel : String?
    enum CodingKeys: String, CodingKey {

        case completedDate = "completedDate"
        case formDataId = "formDataId"
        case status = "status"
        case statusLabel = "statusLabel"
        case subjectFullName = "subjectFullName"
        case subjectId = "subjectId"
        case url = "url"
        case wfRequestUINav = "wfRequestUINav"
        case timeType = "timeType"
        case peroid = "peroid"
        case planned = "planned"
        case approvalStatus = "approvalStatus"
        case isSelected = "isSelected"
        case createdOn = "createdOn"
        case wfRequestId = "wfRequestId"
        case categoryLabel = "categoryLabel"
         case workflowAllowedActionListNav = "workflowAllowedActionListNav"
    }
}

struct Todos : Codable {
    let results2 : [Results2]?

    enum CodingKeys: String, CodingKey {

        case results2 = "results"
    }
}
struct workflowAllowedActionListNav:Codable {
     let results : [workflowAllowedActionListNavModel]?
       enum CodingKeys: String, CodingKey {
           case results = "results"
       }
}
struct workflowAllowedActionListNavModel:Codable {
     let allowReject : Bool?
    let allowApprove : Bool?
       enum CodingKeys: String, CodingKey {
           case allowReject = "allowReject"
        case allowApprove = "allowApprove"
       }
}
struct WfRequestUINav : Codable {
    let wfRequestId : String?
    let businessUnit : String?
    let operateUserName : String?
    let legalEntity : String?
    let jobTitle : String?
    let division : String?
    let receivedOn : String?
    let department : String?
    let costCenter : String?
    let todoSubjectLine : String?
    let operateType : String?
    let subjectUserId : String?
    let location : String?
    let operateDate : String?
    let subjectUserName : String?
    let actionType : String?
    let changedData : String?
    var objectType : String?
    var approverChangedData : [ApproverChangedData]?
    enum CodingKeys: String, CodingKey {
        case wfRequestId = "wfRequestId"
        case businessUnit = "businessUnit"
        case operateUserName = "operateUserName"
        case jobTitle = "jobTitle"
        case legalEntity = "legalEntity"
        case receivedOn = "receivedOn"
        case division = "division"
        case department = "department"
        case costCenter = "costCenter"
        case todoSubjectLine = "todoSubjectLine"
        case operateType = "operateType"
        case subjectUserId = "subjectUserId"
        case location = "location"
        case operateDate = "operateDate"
        case subjectUserName = "subjectUserName"
        case actionType = "actionType"
        case changedData = "changedData"
        case objectType = "objectType"
        case approverChangedData = "approverChangedData"
    }
}

struct TimeSheetRequestDetailModel:Codable {
     let d : TimeSheetRequestDetailModelData?
       enum CodingKeys: String, CodingKey {
           case d = "d"
       }
}
struct TimeSheetRequestDetailModelData:Codable {
     let wfRequestId : String?
     let lastModifiedDateTime : String?
     let lastModifiedBy : String?
    let wfRequestUINav : WfRequestUINav?
    let workflowAllowedActionListNav : workflowAllowedActionListNav?
    let status : String?
       enum CodingKeys: String, CodingKey {
           case wfRequestId = "wfRequestId"
           case lastModifiedDateTime = "lastModifiedDateTime"
           case lastModifiedBy = "lastModifiedBy"
           case wfRequestUINav = "wfRequestUINav"
           case status = "status"
            case workflowAllowedActionListNav = "workflowAllowedActionListNav"
       }
}

struct ApproverChangedData : Codable{
    let label : String?
    let newValue : String?
    let oldValue : String?
    enum CodingKeys: String, CodingKey {
        case label = "label"
        case newValue = "newValue"
        case oldValue = "oldValue"
    }
}

struct ApprovalRequestSuccess:Codable {
       let d : ApprovalRequestSuccessModel?
        enum CodingKeys: String, CodingKey {
            case d = "d"
        }
}

struct ApprovalRequestSuccessModel: Codable{
    var wfRequestId : String?
    var status : String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case wfRequestId = "wfRequestId"
    }
}
