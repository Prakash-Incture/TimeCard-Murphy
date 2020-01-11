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
    
    static var defaultHeaders: HTTPHeader = ["Content-Type": "application/json", "Accept" : "application/json","cache-control": "no-cache"]
    static var lookUpApi = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/TimeTypeProfile"
    static var empTimeOffBalance = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Time-off-Balance"
    static var empJob = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Emp-Job"
    static var holidayCalender = "https://l5470-iflmap.hcisbp.us2.hana.ondemand.com/http/Holiday_Calender"

}

enum ServiceEndpoints {
    case lookUpApicalling(params:UserData)
    case empTimeofBalance(params:UserData)
    case empJob(params:UserData)
    case holidayCalender(paramas:UserData)
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
        }
      }
        func urlRequest(for urlString: String, method: String = "GET", body: UserData? = nil) -> URLRequest {
             let urlStringVal = urlString.replacingOccurrences(of: " ", with: "")
            let url = URL(string: urlStringVal)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method
            LinkingUrl.defaultHeaders.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            urlRequest.addValue("Basic UDAwMTI1NDpDaGFpdGFueWFAMg==", forHTTPHeaderField: "Authorization")
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
    func userAuthorizationHeaders() -> String{
        let username = "P001254"
        let password = "Chaitanya@2"
        let loginString = String(format:"\(username)\(password)")
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
   
}

