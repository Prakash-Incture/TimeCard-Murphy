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

    enum CodingKeys: String, CodingKey {

        case completedDate = "completedDate"
        case formDataId = "formDataId"
        case status = "status"
        case statusLabel = "statusLabel"
        case subjectFullName = "subjectFullName"
        case subjectId = "subjectId"
        case url = "url"
    }
}

struct Todos : Codable {
    let results2 : [Results2]?

    enum CodingKeys: String, CodingKey {

        case results2 = "results"
    }
}


