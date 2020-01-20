//
//  RequestManger.swift
//  Task-Management
//
//  Created by Arjun on 24/06/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation
import CoreData
//import Alamofire

class RequestManager<ResponseType: Codable> {
    // Return odel Object
    let urlSession = URLSession.shared
    
    func getData(_ request: URLRequest, completion: CompletionHandler<ResponseType>? = nil, offlineCompletion: ((Data) -> Void)? = nil) -> Void {
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            let defaultError = "Something went wrong, please try again later."
            guard let data = data else {
                completion?(APIResponse.failure(mesaage: error?.localizedDescription ?? defaultError))
                return
            }
          if  let completeData = String(data: data, encoding: .utf8) {
                        print("\n\n\n Response Received Data: \n \(completeData)\n\n\n")
                    }

            completion?(APIResponse<ResponseType>.successData(value: data))
            do {
                let parsedData = try JSONDecoder().decode(ResponseType.self, from: data)
                completion?(APIResponse<ResponseType>.success(value: parsedData, message: "Success"))
            } catch {
                completion?(APIResponse<ResponseType>.failure(mesaage: "Data Not Found"))
            }
        }
        task.resume()
    }
}

enum APIResponse<T> {
    case failure(mesaage: String)
    case success(value: T?, message: String?)
    case successData(value: Data)
}
typealias CompletionHandler<Entity> = (_ response: APIResponse<Entity>) -> Void
