//
//  AllocationViewModel.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import Foundation
public enum AllocationReuseIdentifier: String {
    case GenericTableviewDropdownCell,AllocatedTimeTableCell,WeekSummaryCell
}
public enum AllocationCellIdentifier: String {
    case timeType = "Time Type"
    case duration = "Duration"
    case costCenter = "Cost Center"
    case addAbscences = "Add Absences"
    case total = "Total"
    case paidAbsences = "Paid Absences"
    case ot = "OT1.5"
    case regularTime = "Regular Time\nPer day"
    case status = "Status"
    
    func getTitleHeader() -> String {
        return self.rawValue
    }
    
    var shouldShowIndicator: Bool {
        switch self {
        case .timeType, .duration, .costCenter, .addAbscences: return true
        default: return false
        }
    }
    var inputViewForSelection: [String] {
           switch self {
           case .timeType: return ["Working Time" , "Over Time", "Continuing Education", "Business Travel"]
           case .costCenter: return ["Cost Center 1" , "Cost Center 2", "Cost Center 3", "Cost Center 4"]
           default:  return []
           }
       }
    var getPlaceHoldertext: String {
           switch self {
           case .timeType, .duration, .costCenter: return "--Select--"
           default:
               return ""
           }
       }
    var isUserIntractable: Bool {
          switch self {
          case .timeType, .duration,.costCenter: return true
          default: return false
          }
      }
}

public enum CurrentPage: Int {
    case newRecording
    case weekSummary
    func getCurrentPageHeaders() -> [[CellModel]] {
       switch self {
            case .newRecording: return AllocationHeader.getAbsenceCells()
            case .weekSummary:  return AllocationHeader.getWeekSummaryCells()
        }
    }
    func titleForHeaderInSection(section: Int) -> String {
         switch self {
         case .newRecording:
            if section == 1{
                return "Absence"
            }
            return ""
         case .weekSummary:
            return ""
        }
    }
}
protocol CellModel {
    var reuseIdentifier : AllocationReuseIdentifier { get set }
    var cellIdentifier : AllocationCellIdentifier { get set }
}
struct Header: CellModel {
    var reuseIdentifier: AllocationReuseIdentifier
    var cellIdentifier: AllocationCellIdentifier
    
    init(reuseIdentifier: AllocationReuseIdentifier, cellIdentifier: AllocationCellIdentifier) {
        self.reuseIdentifier = reuseIdentifier
        self.cellIdentifier = cellIdentifier
    }
}
class AllocationHeader {

static func getAllocationCells() -> [CellModel] {
    var rowModel : [CellModel] = [CellModel]()
    rowModel.append(Header(reuseIdentifier: .GenericTableviewDropdownCell, cellIdentifier: AllocationCellIdentifier.timeType))
     rowModel.append(Header(reuseIdentifier: .GenericTableviewDropdownCell, cellIdentifier: AllocationCellIdentifier.duration))
     rowModel.append(Header(reuseIdentifier: .GenericTableviewDropdownCell, cellIdentifier: AllocationCellIdentifier.costCenter))
     return rowModel
   }
    static func getAbsenceCells() -> [[CellModel]] {
     var rowModel : [[CellModel]] = [[CellModel]]()
        rowModel = [
         [Header(reuseIdentifier: .AllocatedTimeTableCell, cellIdentifier: AllocationCellIdentifier.timeType)],
          [Header(reuseIdentifier: .GenericTableviewDropdownCell, cellIdentifier: AllocationCellIdentifier.addAbscences)]
        ]
           return rowModel
    }
    static func getWeekSummaryCells() -> [[CellModel]]{
        var rowModel : [[CellModel]] = [[CellModel]]()
       rowModel = [
            [Header(reuseIdentifier: .WeekSummaryCell, cellIdentifier: AllocationCellIdentifier.total),
          Header(reuseIdentifier: .WeekSummaryCell, cellIdentifier: AllocationCellIdentifier.paidAbsences),
          Header(reuseIdentifier: .WeekSummaryCell, cellIdentifier: AllocationCellIdentifier.ot),
            Header(reuseIdentifier: .WeekSummaryCell, cellIdentifier: AllocationCellIdentifier.regularTime),
            Header(reuseIdentifier: .WeekSummaryCell, cellIdentifier: AllocationCellIdentifier.status)
            ],
          [Header(reuseIdentifier: .AllocatedTimeTableCell, cellIdentifier: AllocationCellIdentifier.total)]
        ]

        return rowModel
    }
}
