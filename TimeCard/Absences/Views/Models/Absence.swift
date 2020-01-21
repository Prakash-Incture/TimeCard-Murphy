//
//  Absence.swift
//  TimeCard
//
//  Created by prakash on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

struct Absence:Codable{
    var timeType,startDate,availableLeaves,endDate,requesting,timeTypeId:String?
    var dateStart, dateEnd: Date?
    var duration: String?
    var durationMin: Int?
}
