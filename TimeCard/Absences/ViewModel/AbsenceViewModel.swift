//
//  AbsenceViewModel.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
enum AbsenceIdentifier:String{
    case timeType = "Time Type"
    case availableBalance = "Available Balance"
    case startDate = "Start Date"
    case endDate = "End Date"
    case requesting = "Requesting"
    
    func getTitleHeader() -> String {
           return self.rawValue
       }
    var shouldShowIndicator: Bool {
          switch self {
          case .timeType, .availableBalance, .startDate, .endDate,.requesting: return true
          }
      }
    var dataForSelection: [String] {
           switch self {
           case .timeType: return ["Vacation","Sickness","Maternity","PTO","Jury Duty","Leave of Absence","Long tern Disability","Short Term Disability","Open Ended Absence","Comp Time"]
           default:  return []
           }
       }
    var getPlaceHoldertext: String {
           switch self {
           case .timeType: return "--Select--"
           default:
               return ""
           }
       }

    var isUserIntractable: Bool {
             switch self {
             case .timeType: return true
             default: return true
             }
         }
}

class AbsenceViewModel{
    var absenceModelIdentifier: AbsenceIdentifier?

}
