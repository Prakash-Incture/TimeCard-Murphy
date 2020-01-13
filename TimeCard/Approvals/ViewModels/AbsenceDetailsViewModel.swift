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
    
    public func getTemData(){
        absenceDetailsModel.absenceDetails = [AbsenceDetail(key: "Reccurence Group", value: "--"),
                                        AbsenceDetail(key: "Deduction Quantity", value: "1"),
                                        AbsenceDetail(key: "Time Type", value: "Vocation"),
                                        AbsenceDetail(key: "Start Date", value: "31 Dec 2019"),
                                        AbsenceDetail(key: "End Date", value: "02 Jan 2019"),
                                        AbsenceDetail(key: "Time Off Used", value: "1 day"),
                                        AbsenceDetail(key: "Balance of 31 Dec 2019", value: "23 days"),
                                        AbsenceDetail(key: "Approval Status", value: "Pending"),
                                        AbsenceDetail(key: "Cancellation Workflow Request", value: "--"),
                                        AbsenceDetail(key: "Flexible Requesting", value: "No"),
                                        AbsenceDetail(key: "Created by", value: "Peter Watson"),
                                        AbsenceDetail(key: "Created on", value: "31 Dec 2019, 08:00"),
                                        AbsenceDetail(key: "Documentation", value: "--"),
                                        AbsenceDetail(key: "Workflow Initiated by Admin", value: "No")]
        
    }
    
}
