//
//  AbsenceDetailsModel.swift
//  TimeCard
//
//  Created by PremKumar on 10/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

struct AbsenceDetailsModel: Codable {
    var absenceDetails: [AbsenceDetail]?
}

struct AbsenceDetail: Codable {
    var key, value : String?
}
