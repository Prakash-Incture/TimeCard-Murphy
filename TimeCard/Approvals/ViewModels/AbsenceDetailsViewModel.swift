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
    
    public func getTemData(data:Results3?){
        let sdates = data?.peroid?.components(separatedBy: "-")
        let startDate = sdates?.first ?? ""
        let endDate = sdates?[1] ?? ""
        let difference = Calendar.current.dateComponents([.hour, .minute], from: (startDate.convertToDate(format: .monthDateYearSlashSeperator, currentDateStringFormat: .monthDateYearSlashSeperator))!, to: (endDate.convertToDate(format: .monthDateYearSlashSeperator, currentDateStringFormat: .monthDateYearSlashSeperator))!)
        let deductionQnt = String(difference.hour!/24)
        absenceDetailsModel.absenceDetails = [AbsenceDetail(key: "Reccurence Group", value: "--"),
                                        AbsenceDetail(key: "Deduction Quantity", value: deductionQnt),
                                        AbsenceDetail(key: "Time Type", value: data?.timeType ?? ""),
                                        AbsenceDetail(key: "Start Date", value: startDate),
                                        AbsenceDetail(key: "End Date", value: endDate),
                                        AbsenceDetail(key: "Time Off Used", value: ""),
                                        AbsenceDetail(key: "Balance of 31 Dec 2019", value: "23 days"),
                                        AbsenceDetail(key: "Approval Status", value: data?.approvalStatus ?? ""),
                                        AbsenceDetail(key: "Cancellation Workflow Request", value: "--"),
                                        AbsenceDetail(key: "Flexible Requesting", value: "No"),
                                        AbsenceDetail(key: "Created by", value: data?.wfRequestUINav?.subjectUserName ?? ""),
                                        AbsenceDetail(key: "Created on", value: data?.wfRequestUINav?.receivedOn ?? ""),
                                        AbsenceDetail(key: "Documentation", value: "--"),
                                        AbsenceDetail(key: "Workflow Initiated by Admin", value: "No")]
        
    }
    
}
