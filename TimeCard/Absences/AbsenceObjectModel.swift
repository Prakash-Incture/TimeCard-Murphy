//
//  AbsenceObjectModel.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 09/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation


struct AbsenceData: Codable {
    var absenceDataModel:[AbsenceObjectModel]?
}
struct AbsenceObjectModel:Codable {
    var timeType,availableBalance,startDate,endDate,requesting:String?
}
