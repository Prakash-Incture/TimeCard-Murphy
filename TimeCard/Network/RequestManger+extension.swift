//
//  ELRequestManger+extension.swift
//  Task-Management
//
//  Created by Arjun on 02/07/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation

// Reusing the same request Manger used in bypass log
extension RequestManager {
    public func fetchlookUpdata(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
        self.getData(ServiceEndpoints.lookUpApicalling(params: userData).getUrlRequest(), completion: completion)
    }
    public func fetchEmpTimeBalance(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
        self.getData(ServiceEndpoints.empTimeofBalance(params: userData).getUrlRequest(), completion: completion)
    }
    public func fetchEmpJob(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
           self.getData(ServiceEndpoints.empJob(params: userData).getUrlRequest(), completion: completion)
       }
    public func holidayCalenderApicall(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
        self.getData(ServiceEndpoints.holidayCalender(paramas: userData).getUrlRequest(), completion: completion)
          }
    public func fetchEmpTime(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
              self.getData(ServiceEndpoints.empTimeApi(params: userData).getUrlRequest(), completion: completion)
          }
    public func getEmployeeTimeSheet(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
        self.getData(ServiceEndpoints.getEmpTimeSheet(params: userData).getUrlRequest(), completion: completion)
    }
    public func fetchEmpWorkSchedule(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
              self.getData(ServiceEndpoints.empWorkSchedule(params: userData).getUrlRequest(), completion: completion)
          }

    public func costCenterAPIcall(for userData:UserData, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
    self.getData(ServiceEndpoints.getCostcenter(params: userData).getUrlRequest(),completion: completion)
      }
    public func postAbsencesData(for params:[String:Any],idpPayload: GetIDPPayload, completion: @escaping ((APIResponse<ResponseType>) -> Void))  {
        self.getData(ServiceEndpoints.postAbsenceData(param: params).getUrlRequest(),completion: completion)
      }
    
    public func fetchAsserionToken(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getAsserionToken(params: params).getUrlRequest(), completion: completion)
    }
    
    public func fetchAccessToken(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getAccessToken(params: params).getUrlRequest(), completion: completion)
    }
    
    
    public func fetchAsserionTokenForTimeSheet(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getAsserionTokenForTimesheet(params: params).getUrlRequest(), completion: completion)
    }
    
    public func fetchAccessTokenForTimeSheet(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getAccessTokenForTimeSheet(params: params).getUrlRequest(), completion: completion)
    }
    
    
    public func fetchTimeSheetData(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getApprovalTimeSheet.getUrlRequest(), completion: completion)
    }
    public func fetchTimeSheetDataById(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
           self.getData(ServiceEndpoints.getApprovalTimeDetail(parm: params).getUrlRequest(), completion: completion)
       }
    public func fetchTimeOffData(for idpPayload: GetIDPPayload, params: String = "", completion: @escaping ((APIResponse<ResponseType>) -> Void)){
        self.getData(ServiceEndpoints.getApprovalTimeOffSheet.getUrlRequest(), completion: completion)
    }
    
}
