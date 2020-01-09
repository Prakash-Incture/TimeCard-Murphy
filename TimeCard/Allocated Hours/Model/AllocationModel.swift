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
