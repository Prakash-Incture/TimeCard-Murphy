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
}
struct AllocationModel:Codable {
    var timeType,duration,costCneter:String?
}

