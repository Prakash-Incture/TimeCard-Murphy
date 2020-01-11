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
    
    let urlSession = URLSession.shared
    
    func getData(_ request: URLRequest, completion: CompletionHandler<ResponseType>? = nil, offlineCompletion: ((Data) -> Void)? = nil) -> Void {
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            let defaultError = "Something went wrong, please try again later."
            guard let data = data else {
                completion?(APIResponse.failure(mesaage: error?.localizedDescription ?? defaultError))
                return
            }
            do {
                print(try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) )
                let parsedData = try JSONDecoder().decode(ResponseType.self, from: data)
                completion?(APIResponse<ResponseType>.success(value: parsedData, message: "Success"))
            } catch {
                print(error.localizedDescription, "StatusCode: \(response!)")
                completion?(APIResponse<ResponseType>.failure(mesaage: "Data Not Found"))
            }
        }
        task.resume()
    }
//    func getObject(_ request: URLRequest, completionHandler: @escaping (_ responseObject: ResponseType?,_ error:NSError?  ) -> ()) -> Void {
//           Alamofire.request(request)
//            .authenticate(user: "P001254", password: "Chaitanya@2")
//               .responseJSON { response in
//                   print(response)
//                   if(response.result.error == nil){
//                       do {
//                           print(response)
//                        if let data:Any = response.result.value {
//                                completionHandler(data as? ResponseType, response.result.error as NSError? )
//
//                           }
//                           else{
//                               print("Something went wrong")
//                             do {
//                               completionHandler(response as? ResponseType, response.result.error as NSError? )
//                            }
//                           }
//                       }
//                   }
//                   else
//                   {
//                       completionHandler(nil, response.result.error as NSError? )
//                   }
//           }
//       }
//
}

enum APIResponse<T> {
    case failure(mesaage: String)
    case success(value: T?, message: String?)
}
typealias CompletionHandler<Entity> = (_ response: APIResponse<Entity>) -> Void
