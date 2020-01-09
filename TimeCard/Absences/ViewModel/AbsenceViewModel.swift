//
//  AbsenceViewModel.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
public enum AbsenceReuseIdentifier: String {
    case AbsenceCell
}
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


struct AbsenceViewModel: CellModelForAbsence {
    var absenceModelIdentifier: AbsenceIdentifier
    
    var reuseIdentifier: AbsenceReuseIdentifier
    
    init(reuseIdentifier: AbsenceReuseIdentifier, cellIdentifier: AbsenceIdentifier) {
        self.reuseIdentifier = reuseIdentifier
        self.absenceModelIdentifier = cellIdentifier
    }
}

protocol CellModelForAbsence {
    var reuseIdentifier : AbsenceReuseIdentifier { get set }
    var absenceModelIdentifier : AbsenceIdentifier { get set }
}

class AbsenceModel{
    static func getAbsenceRecordCells() -> [CellModelForAbsence] {
     var rowModel : [CellModelForAbsence] = [CellModelForAbsence]()
        rowModel.append(AbsenceViewModel(reuseIdentifier: .AbsenceCell, cellIdentifier: AbsenceIdentifier.timeType))
        rowModel.append(AbsenceViewModel(reuseIdentifier: .AbsenceCell, cellIdentifier: AbsenceIdentifier.availableBalance))
        rowModel.append(AbsenceViewModel(reuseIdentifier: .AbsenceCell, cellIdentifier: AbsenceIdentifier.startDate))
        rowModel.append(AbsenceViewModel(reuseIdentifier: .AbsenceCell, cellIdentifier: AbsenceIdentifier.endDate))
        rowModel.append(AbsenceViewModel(reuseIdentifier: .AbsenceCell, cellIdentifier: AbsenceIdentifier.requesting))
      return rowModel
    }
}
public enum AbsenceCurrentPage: Int {
    case absenceRecording
    func getCurrentPageHeaders() -> [CellModelForAbsence] {
       switch self {
       case .absenceRecording: return AbsenceModel.getAbsenceRecordCells()
        }
    }
    func titleForHeaderInSection(section: Int) -> String {
            return ""
        }
}
