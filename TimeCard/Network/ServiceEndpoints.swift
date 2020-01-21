//
//  ELServiceEndpoints.swift
//  Task-Management
//
//  Created by Arjun on 02/07/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
typealias HTTPHeader = [String: String]

struct LinkingUrl {
    static var defaultHeaders: HTTPHeader = ["Accept" : "application/json","cache-control": "no-cache", "Content-Type": "application/json"]
    static var urlEncodeHeaders: HTTPHeader = ["Content-Type": "application/x-www-form-urlencoded"]
    static var lookUpApi = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/TimeTypeProfile"
    static var empTimeOffBalance = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Time-off-Balance"
    static var empJob = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Emp-Job"
    static var empTime = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/EmployeeTime"
    static var workSchedule = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/WorkSchedule"
    static var employeeTimeSheet = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/EMP_time"
    static var holidayCalender = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Holiday_Calender"
    static var idpUrl = "https://apisalesdemo4.successfactors.com/oauth/idp"
    static var accessTokenUrl = "https://apisalesdemo4.successfactors.com/oauth/token"
    static var approvalTimeSheetGet = "https://apisalesdemo4.successfactors.com/odata/v2/Todo?$filter=status%20eq%20%272%27%20and%20categoryId%20eq%20%2718%27%20&$format=json"
    static var approvalTimeOffGet = "https://apisalesdemo4.successfactors.com/odata/v2/Todo?$filter=status%20eq%20%272%27%20and%20categoryId%20eq%20%2729%27%20&$format=json"
    
    
    static var approvalTimeDetail = "https://apisalesdemo4.successfactors.com/odata/v2/WfRequest(5820)?$filter=wfRequestUINav, workflowAllowedActionListNav, wfRequestParticipatorNav,wfRequestCommentsNav&$expand=wfRequestUINav, workflowAllowedActionListNav, wfRequestParticipatorNav,wfRequestCommentsNav&$format=json"
    static var costcenter = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/EmpCostDistributionItem"
     static var postAbsencesData = "https://api4preview.sapsf.com/odata/v2/upsert?workflowConfirmed=true"
    static var idpForTimeSheet = "https://api4preview.sapsf.com/oauth/idp"
    static var accessTokenforTimeCard = "https://api4preview.sapsf.com//oauth/token"

}

enum ServiceEndpoints {
    case lookUpApicalling(params:UserData)
    case empTimeofBalance(params:UserData)
    case empJob(params:UserData)
    case holidayCalender(paramas:UserData)
    case getAsserionToken(params: String) // POST
    case getAccessToken(params: String) // POST
    case getAsserionTokenForTimesheet(params: String) // POST
    case getAccessTokenForTimeSheet(params: String) // POST
    case getApprovalTimeSheet
    case getApprovalTimeOffSheet
    case postAbsenceData(param:[String:Any])
    case getCostcenter(params: UserData)
    case empWorkSchedule(params:UserData)
    case empTimeApi(params:UserData)
    case getEmpTimeSheet(params:UserData)
    case getApprovalTimeDetail(parm:String)
    case getApprovalTimeSheetDetail(parm:String)
    case getApprovalTimeOffDetail(parm:String)
    case postApproveRequest(id:String)
    case postApprovereject(id:String)
    
    func getUrlRequest() -> URLRequest {
        switch self {
        case .lookUpApicalling(let userData):
            let urlString = LinkingUrl.lookUpApi
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .empTimeofBalance(let userData):
            let urlString = LinkingUrl.empTimeOffBalance
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .empJob(let userData):
            let urlString = LinkingUrl.empJob
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .holidayCalender(let userData):
            let urlString = LinkingUrl.holidayCalender
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .getAsserionToken(let paramsStr):
            let urlString = LinkingUrl.idpUrl
            return self.urlRequestWithStringBody(for: urlString, method: "POST", body: paramsStr, addHeader: false)
        case .getAccessToken(let paramStr):
            let urlStr = LinkingUrl.accessTokenUrl
            return self.urlRequestWithStringBody(for: urlStr, method: "POST", body: paramStr, addHeader: false)
        case .getApprovalTimeSheet:
            let urlStr = LinkingUrl.approvalTimeSheetGet
            return self.urlRequestWithStringBody(for: urlStr, method: "GET", body: nil, addHeader: true)
        case .getApprovalTimeOffSheet:
            let urlStr = LinkingUrl.approvalTimeOffGet
            return self.urlRequestWithStringBody(for: urlStr, method: "GET", body: nil, addHeader: true)
        case .getCostcenter(let userData):
             let urlStr = LinkingUrl.costcenter
            return self.urlRequest(for: urlStr, method: "POST", body:userData)
        case .postAbsenceData(let param):
            let urlStr = LinkingUrl.postAbsencesData
            return self.urlRequestWithBody(for: urlStr, method: "POST", body: param, addHeader: true)
        case .getAsserionTokenForTimesheet(let paramsStr):
              let urlStr = LinkingUrl.idpForTimeSheet
            return self.urlRequestWithStringBody(for: urlStr, method: "POST", body: paramsStr, addHeader: false)
        case .getAccessTokenForTimeSheet(let paramsStr):
            let urlString = LinkingUrl.accessTokenforTimeCard
            return self.urlRequestWithStringBody(for: urlString, method: "POST", body: paramsStr, addHeader: false)
        case .empWorkSchedule(let userData):
            let urlString = LinkingUrl.workSchedule
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .empTimeApi(let userData):
            let urlString = LinkingUrl.empTime
            return self.urlRequest(for: urlString, method: "POST", body:userData)
        case .getEmpTimeSheet(let params):
            let urlString = LinkingUrl.employeeTimeSheet
            return self.urlRequest(for: urlString, method: "POST", body:params)
        case .getApprovalTimeDetail(let parm):
            let url = "https://apisalesdemo4.successfactors.com/odata/v2/WfRequest(\(parm))?$filter=wfRequestUINav, workflowAllowedActionListNav&$expand=wfRequestUINav, workflowAllowedActionListNav&$format=json"
            return self.urlRequestWithStringBody(for: url, method: "GET", body: nil, addHeader: true)
        case .postApproveRequest(let id):
            let url = "https://apisalesdemo4.successfactors.com/odata/v2/approveWfRequest?wfRequestId=" + id + "L"
            return self.urlRequestWithoutStringBody(for: url, method:"POST", body:nil ,addHeader: true)
        case .postApprovereject(let id):
                 let url = "https://apisalesdemo4.successfactors.com/odata/v2/rejectWfRequest?wfRequestId=" + id + "L"
                 return self.urlRequestWithoutStringBody(for: url, method:"POST", body:nil ,addHeader: true)
        case .getApprovalTimeOffDetail(let parm):
             let url = "https://apisalesdemo4.successfactors.com/odata/v2/EmployeeTime?$filter=workflowRequestId eq '\(parm)'&$select=startDate,endDate,deductionQuantity,createdDate,createdBy,workflowInitiatedByAdmin,userIdNav,timeCalendar,timeTypeNav,approvalStatusNav&$expand=userIdNav,timeCalendar,timeTypeNav,approvalStatusNav&$format=json"
                return self.urlRequestforGet(for: url, method: "GET", body: nil, addHeader: true)
        case .getApprovalTimeSheetDetail(let parm):
            let url = "https://apisalesdemo4.successfactors.com/odata/v2/EmployeeTimeSheet?$filter=workflowRequestId eq '\(parm)'&$select=period,plannedHoursAndMinutes,workingTimeAccountHoursAndMinutes,recordedHoursAndMinutes,userIdNav,employeeTimeSheetEntry,employeeTimeValuationResult&$expand=userIdNav,employeeTimeSheetEntry,employeeTimeValuationResult&$format=json"
                return self.urlRequestforGet(for: url, method: "GET", body: nil, addHeader: true)
        }
      }
    
    func urlRequest(for urlString: String, method: String = "GET", body: UserData? = nil, addHeader: Bool = true) -> URLRequest {
             let urlStringVal = urlString.replacingOccurrences(of: " ", with: "")
            let url = URL(string: urlStringVal)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method
            LinkingUrl.defaultHeaders.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        if addHeader{
            urlRequest.addValue("Basic UDAwMTI1NDpDaGFpdGFueWFAMg==", forHTTPHeaderField: "Authorization")
        }
            guard let body = body else { return urlRequest }
            
            do {
                let body = try JSONEncoder().encode(body)
                print(try JSONSerialization.jsonObject(with: body, options: JSONSerialization.ReadingOptions.allowFragments))
                urlRequest.httpBody = body
            } catch {
                print(error.localizedDescription)
            }
            
            return urlRequest
        }
    
    func urlRequestWithStringBody(for urlString: String, method: String = "GET", body: String?, addHeader: Bool = true) -> URLRequest {
                let urlStringVal = urlString.replacingOccurrences(of: " ", with: "")
                let url = URL(string: urlStringVal)
                var urlRequest = URLRequest(url: url!)
                urlRequest.httpMethod = method
                LinkingUrl.urlEncodeHeaders.forEach { (key, value) in
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            if addHeader{
                let accessToken = UserDefaults.standard.object(forKey: ApproveConstants.accessToken as? String ?? "")
                urlRequest.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
        if method == "POST"{
                    guard let body = body else { return urlRequest }
                    if let postData = body.data(using: .utf8) {
                    urlRequest.httpBody = postData
            }
        }
                return urlRequest
    }
    func urlRequestforGet(for urlString: String, method: String = "GET", body: String?, addHeader: Bool = true) -> URLRequest {
                let urlStringVal = urlString.replacingOccurrences(of: " ", with: "%20")
                let url = URL(string: urlStringVal)
                var urlRequest = URLRequest(url: url!)
                urlRequest.httpMethod = method
                LinkingUrl.urlEncodeHeaders.forEach { (key, value) in
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            if addHeader{
                let accessToken = UserDefaults.standard.object(forKey: ApproveConstants.accessToken as? String ?? "")
                urlRequest.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
        if method == "POST"{
                    guard let body = body else { return urlRequest }
                    if let postData = body.data(using: .utf8) {
                    urlRequest.httpBody = postData
            }
        }
                return urlRequest
    }
    func urlRequestWithoutStringBody(for urlString: String, method: String = "GET", body: String?, addHeader: Bool = true) -> URLRequest {
                let urlStringVal = urlString.replacingOccurrences(of: " ", with: "")
                let url = URL(string: urlStringVal)
                var urlRequest = URLRequest(url: url!)
                urlRequest.httpMethod = method
                LinkingUrl.defaultHeaders.forEach { (key, value) in
                                   urlRequest.setValue(value, forHTTPHeaderField: key)
                               }
            if addHeader{
                let accessToken = UserDefaults.standard.object(forKey: ApproveConstants.accessToken as? String ?? "")
                urlRequest.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
            }
        if method == "POST"{
                    guard let body = body else { return urlRequest }
                    if let postData = body.data(using: .utf8) {
                    urlRequest.httpBody = postData
            }
        }
                return urlRequest
    }
    
    
    
    func urlRequestWithBody(for urlString: String, method: String = "GET", body: [String:Any]?, addHeader: Bool = true)  -> URLRequest {
                let urlStringVal = urlString.replacingOccurrences(of: " ", with: "")
                let url = URL(string: urlStringVal)
                var urlRequest = URLRequest(url: url!)
                urlRequest.httpMethod = method

        LinkingUrl.defaultHeaders.forEach { (key, value) in
                     urlRequest.setValue(value, forHTTPHeaderField: key)
                 }
            if addHeader{
                let accessToken = UserDefaults.standard.object(forKey: accessTokenForTimeSheet) ?? ""
                urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        if method == "POST"{
            guard let body = body else { return urlRequest }
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print(error)
            }
        }
                return urlRequest
    }
    func userAuthorizationHeaders() -> String{
        let username = "P001254"
        let password = "Chaitanya@2"
        let loginString = String(format:"\(username)\(password)")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
}

enum QHTTPFormURLEncoded {
  
    static let contentType = "application/x-www-form-urlencoded"
  
    static func urlEncoded(formDataSet: [String: String]) -> String {
        return formDataSet.map { (key, value) in
            return escape(key) + "=" + escape(value)
        }.joined(separator: "&")
    }
  
    private static func escape(_ str: String) -> String {
        return str.replacingOccurrences(of: "\n", with: "\r\n")
            .addingPercentEncoding(withAllowedCharacters: sAllowedCharacters)!
            .replacingOccurrences(of: " ", with: "+")
    }
    private static let sAllowedCharacters: CharacterSet = {
        // Start with `CharacterSet.urlQueryAllowed` then add " " (it's converted to "+" later)
        // and remove "+" (it has to be percent encoded to prevent a conflict with " ").
        var allowed = CharacterSet.urlQueryAllowed
        allowed.insert(" ")
        allowed.remove("+")
        allowed.remove("/")
        allowed.remove("?")
        return allowed
    }()
}
