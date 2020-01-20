//
//  File.swift
//  TimeCard
//
//  Created by PremKumar on 08/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

struct TimeSheetDetailsModel: Codable {
    var timeSheetEntry: [TimeSheetEntryData]?
    var timeValuation: [TimeValuationData]?
}

struct TimeSheetEntryData: Codable {
    var timeType, startDate, costCenter, hoursAndMin: String?
}

struct TimeValuationData: Codable {
    var payTimeName, hoursAndMin, costCenter, bookingDate: String?
}
