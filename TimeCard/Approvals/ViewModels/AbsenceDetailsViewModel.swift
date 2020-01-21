//
//  AbsenceDetailsViewModel.swift
//  TimeCard
//
//  Created by PremKumar on 10/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation

class AbsenceDetailsViewModel {
    var absenceDetailsModel = AbsenceDetailsModel()
    
    public func getTemData(data:TimeOffDetailsData?){
        var startDate = ""
        let stringArray = data?.startDate?.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray! {
            if let number = Int(item) {
                let date = Date(milliseconds: Int64(number))
                startDate = date.toDateFormat(.dayMonthYear)
            }
        }
     
        var endDate =  ""
        let array = data?.endDate?.components(separatedBy: CharacterSet.decimalDigits.inverted)
              for item in array! {
                  if let number = Int(item) {
                      let date = Date(milliseconds: Int64(number))
                      endDate = date.toDateFormat(.dayMonthYear)
                  }
              }
        var createdDate =  ""
        let createdArray = data?.createdDate?.components(separatedBy: CharacterSet.decimalDigits.inverted)
              for item in createdArray! {
                  if let number = Int(item) {
                      let date = Date(milliseconds: Int64(number))
                      createdDate = date.toDateFormat(.dayMonthYear)
                  }
              }
        absenceDetailsModel.absenceDetails = [
                                              AbsenceDetail(key: "Deduction Quantity", value: data?.deductionQuantity ?? ""),
                                              AbsenceDetail(key: "Time Type", value: data?.timeTypeNav?.externalName_en_US ?? ""),
                                              AbsenceDetail(key: "Start Date", value: startDate),
                                        AbsenceDetail(key: "End Date", value: endDate),
                                        AbsenceDetail(key: "Time Off Used", value: ""),
                                        AbsenceDetail(key: "Approval Status", value: data?.approvalStatusNav?.value ?? ""),
                                        AbsenceDetail(key: "Flexible Requesting", value: data?.timeTypeNav?.flexibleRequestingAllowed == true ? "Yes":"No"),
                                        AbsenceDetail(key: "Cancellation Workflow Request", value: data?.timeTypeNav?.activateCancellationWorkflow == true ? "Yes":"No"),
                                        AbsenceDetail(key: "Created by", value: data?.timeTypeNav?.createdBy ?? ""),
                                        AbsenceDetail(key: "Created on", value:  createdDate),
                                        AbsenceDetail(key: "Workflow Initiated by Admin", value: data?.workflowInitiatedByAdmin == true ? "Yes" : "No")]
        
    }
    
}
