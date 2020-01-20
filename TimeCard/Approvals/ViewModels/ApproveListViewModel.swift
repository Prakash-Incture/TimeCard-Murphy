//
//  ApproveListViewModel.swift
//  TimeCard
//
//  Created by PremKumar on 13/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
import UIKit
struct ApproveConstants {
    static let clientId = "YWE0NzYxMjQzMGU4OWZkNGQ5Y2NkZjQ1MmRlOQ"
    static let userId = "sfadmin"
    static let tokenUrl = "https://apisalesdemo4.successfactors.com/oauth/token"
    static let privatekay = "TUlJRXZnSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS2d3Z2dTa0FnRUFBb0lCQVFDemtVY1BKTzYrcG9vOHp0anRhUGE1MEJXTzRQVUQwNnJBcUVhU0dkZGRWSW4rZkd6SExEN0VEZzlacmlwUjloNlZBQ2N1Y2dlWGV4NjFQS05SZ1NlU05XOGlDZXk2bWxhMG5oWjlzOEY3TWlseURjaFRrTlJuWUxzOUIrWU4waThnWUV2b2xRNFRPTDAvcmtRaVl5eFp0cTROVWRpWU5jbFd0U3RTeFRUZGFneFJBaklLYWNPYzJlL1JxeS9zVkg3bittRmQ3czZ1ejVudU9iQXIxTGR6NkRNUklScGIwZC9qWkhwUExSYXQ5NGpRV2ZySnRTb0dNWFQ0RVJNanRXUU10VG5Jd1ppc2ZFdzBvOG00MGxSd1BvODU4azdQNElMbE55R1BYcGowcE90ZHVHaTAwWWE3MDNIcEJHRjZzQmhwdGh4RlRtMGRoY2pZRUxPakhNU25BZ01CQUFFQ2dnRUFJZS9aQURHNHRXdUFRTkhQQ2IrR3NjTno3NWJ3ZDVLdmVNM1UySlB0c2dQaU9LaUhYblVzUDUxd3BVQlhXem9xdVhwWDdWMDd0aE5jMEYvdmRkMzAvcHIrcis0MFFXZ2Q3dkRaeTFRSHd5TE4xbkpvWS9MQlVmQmtNcnFsYmdORlNOY3FRWUM2TWtQTThKWWM1bXJiM1BDN29HVFJqS0xOdElkMDhxVzJ3Z21Sd2VsR2tsZ20xSVhqbytYZVRoa2Vja2h5VSthMEpsRXRjVmMzNWwrRC9SSlZ0RDRNOEhqeERNaXI1RVcyNE9Va2FoazVKblo3cWVDSWVGOUlmbTY1emY4bnJNL3dNYkhxM3Fwcm80dWZTa096SGl2TXBVT3phWTFWMzJPVEs4Vk5LaVlpOTVFNmZZRS9HUW1Dc01hM1dXNm1HT2xleGR6WDlLd3E5MkloNFFLQmdRRGZZTHJ1Uml4WVJSWlptbTRtL3pJTFZYSFBqV20zdTZsbkZHeG9mbXFLMS96QXZGd3ZhZG9yajY2cFVuajBiK3VIWnlaN1VvNVJsVTFEVk96cndmejM3OCsrVHYzNDJQYlVCekFZbTVacDFkZzNjTUNPQ3dvYTJqVFJsdG4weHdNVFl4bFc2ZEFYMjNZakhhQnJVVWFTZVdQR3hOY0ZvUUJTc0QxMUtzMEU3d0tCZ1FETnlxUHVxVnNkeDlybHdLY1o5VFVLdG5wcmNsVTRhV01OT1RHcGNxVkhWNHFwSWM1RzNpdHRSajE0Ykh5dFZDbHBEdmhSb1JNMU1abXlqSFBLMVlWOWdEV1pwdjZza00wWVEzL01HNk1lSElJWHdmRUFuTkR2bWpuc0t4V3VadXBlNmc5R3dIWHJhTjFiZXFXUnFtVllkd24yYjVJU3VGZ0pNNFZmWWl4cnlRS0JnUUNUN1BMZHFBcmx5WnFyYStGV1lkazZPRE5PUjArakpOdGlMOXc2dHJ6SGhaRVQ4YWo2blJhbGtsa1FPRlZ4U2t5bk5sLzlld1pVY0pMaDYvT1pqTFdCVzRZdmVSQW5JMGNSMGxDL2V3bDR2T3lhaWtoNXlFWEEwby8zMi9ZcWEwQldMbUl4ZEZVaDkydWNoWm9lZDR4TW82YTNrdEx5SDFTZmJhYkZXTHE4Y1FLQmdHZER4aHNlbElCUEowS2U5N3NJMW9MM3FscDhWdE1sM3ZSbHZNdmdvWnM1REhWdVowb2NkZ0l4ZXVzUTFVZE1zakxydGlPUUJrbHRDRWtXUFl5TXRKMlRWbEl5QUIycjA1N1hVQ3VsdXFhRGU2eGNQNGtsSjVyejh4alZUZDNqK3J1Q0RBUmUwMDA3bzhnaHRTOXhKOFhLaGc5SlVTMWZuNTJPWXVESUxLNHhBb0dCQUpQU0tLdXN1RHlXOFdLZi9kR0pCb0gxVkd4ZFVxYXczUFQzTVBUOXNMZngrVHlISHJnbWxQS2xqLytKNlZjQ1IveVJhNjFMTXkyTHFhREpDRFZlL0lldDhDUG5aaXhYSStaeFVYSGd0MUY1dldBQlhtTy9hM1FFRVd3emIrM3BnWkF5TGdHTEpGWEY0SlJEUVFVL1NvTFVHNmhnZGhYck02OHdjVW96akNwaSMjI1NGUEFSVDA0MjQzMQ=="
    
    static let grantType = "urn:ietf:params:oauth:grant-type:saml2-bearer"
    static let companyId = "SFPART042431"
    
    //UserDefaultKeys:
    static let assertionToken = "AssertionToken"
    static let accessToken = "AccessToken"
}

class ApproveListViewModel {
    weak var delegate: GenericViewModelProtocol?
    var dispatchGroup: DispatchGroup = DispatchGroup()
    var tableView : UITableView?
    var updateUI : (()->())?
//    init(delegate:GenericViewModelProtocol) {
//        self.delegate = delegate
//    }
    
    lazy var getAssertionToken = RequestManager<ApproveListModels>()
    var idpPayload: GetIDPPayload?
    var timeSheetArray = [Results3]()
    var timeArray = [Results1]()
}

extension ApproveListViewModel{
    // Get assertion token
    func callAPIForGettingAssertionToken() {
        self.delegate?.showLoadingIndicator = true
        
        let idpBody: [String: String] = ["client_id": ApproveConstants.clientId, "user_id": ApproveConstants.userId, "token_url": ApproveConstants.tokenUrl, "private_key": ApproveConstants.privatekay]
        let idpBodyStr = QHTTPFormURLEncoded.urlEncoded(formDataSet: idpBody)

        self.getAssertionToken.fetchAsserionToken(for:idpPayload ?? GetIDPPayload(), params: idpBodyStr, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .successData(value: let value):
                let dataStr = String(data: value, encoding: .utf8)!
                UserDefaults.standard.set(dataStr, forKey: ApproveConstants.assertionToken)
                UserDefaults.standard.synchronize()
                self.delegate?.showLoadingIndicator = false
                self.callAPIForGettingAccessToken()
            case .success( _, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
            }
        })
    }
    
    // Get access token
        func callAPIForGettingAccessToken() {
            self.delegate?.showLoadingIndicator = true
            
            let idpBody: [String: String] = ["client_id": ApproveConstants.clientId, "grant_type": ApproveConstants.grantType, "company_id": ApproveConstants.companyId, "assertion": UserDefaults.standard.object(forKey: ApproveConstants.assertionToken) as? String ?? ""]
            let idpBodyStr = QHTTPFormURLEncoded.urlEncoded(formDataSet: idpBody)
            
            self.getAssertionToken.fetchAccessToken(for:idpPayload ?? GetIDPPayload(), params: idpBodyStr, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let message):
                    self.delegate?.failedWithReason(message: message)
                    self.delegate?.showLoadingIndicator = false
                case .successData(value: let value):
                    do {
                        if let jsonObj = try JSONSerialization.jsonObject(with: value, options : .allowFragments) as? Dictionary<String, Any>
                        {
                           UserDefaults.standard.set(jsonObj["access_token"], forKey: ApproveConstants.accessToken)
                           UserDefaults.standard.synchronize()
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                    self.delegate?.showLoadingIndicator = false
                    self.callAPIForGettingTimeSheetData()
                case .success( _, let message):
                    print(message as Any)
                    self.delegate?.showLoadingIndicator = false
                }
            })
        }
    
    // Get TimeSheet datas
        func callAPIForGettingTimeSheetData() {
            self.delegate?.showLoadingIndicator = true
            
            self.getAssertionToken.fetchTimeSheetData(for:idpPayload ?? GetIDPPayload(), params: "", completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let message):
                    self.delegate?.failedWithReason(message: message)
                    self.delegate?.showLoadingIndicator = false
                case .successData(value: let value):

                    do {
                        let result = try JSONDecoder().decode(TimeSheetRequestModel.self, from: value )
                        let timeSheetArr = result.d?.results1?[0].todos?.results2?[0].entries?.results3
                        self.timeArray = result.d?.results1 ?? [Results1]()
                        self.timeSheetArray.append(contentsOf: timeSheetArr!)
                      self.callAPIForGettingTimeOffData()

                    } catch {
                        print(error.localizedDescription)
                    }
                case .success( _, let message):
                    print(message as Any)
                    self.delegate?.showLoadingIndicator = false
                }
            })
        }
    
    // Get TimeOff datas
            func callAPIForGettingTimeOffData() {
                self.delegate?.showLoadingIndicator = true
                
                self.getAssertionToken.fetchTimeOffData(for:idpPayload ?? GetIDPPayload(), params: "", completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let message):
                        self.delegate?.failedWithReason(message: message)
                        self.delegate?.showLoadingIndicator = false
                    case .successData(value: let value):

                        do {
                            let result = try JSONDecoder().decode(TimeSheetRequestModel.self, from: value )
                            let timeSheetArr = result.d?.results1?[0].todos?.results2?[0].entries?.results3
                            self.timeSheetArray.append(contentsOf: timeSheetArr!)
                            for (index,item) in self.timeSheetArray.enumerated(){
                                                       self.getTimeSheetDataById(id: item.subjectId ?? "", index: index)
                                                   }
                            print("Array count: \(self.timeSheetArray.count)")

                        } catch {
                            print(error.localizedDescription)
                        }
                        self.delegate?.showLoadingIndicator = false
                    case .success( _, let message):
                        print(message as Any)
                        self.delegate?.showLoadingIndicator = false
                    }
                })
            }
    
    func getTimeSheetDataById(id:String,index:Int){
        self.getAssertionToken.fetchTimeSheetDataById(for: idpPayload ?? GetIDPPayload(),params: id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let message):
                self.delegate?.failedWithReason(message: message)
                self.delegate?.showLoadingIndicator = false
            case .successData(value: let value):

                do {
                    let result = try JSONDecoder().decode(TimeSheetRequestDetailModel.self, from: value )
                    self.timeSheetArray[index].wfRequestUINav = result.d?.wfRequestUINav
                    var jsonString = self.timeSheetArray[index].wfRequestUINav?.changedData ?? ""
                   jsonString = jsonString.replacingOccurrences(of: "\\", with: "")
                   jsonString = jsonString.replacingOccurrences(of: "//", with: "")
                    print(jsonString)
                    
                    var approverChangedData = [ApproverChangedData]()
  
                    
                    let data = Data(jsonString.utf8)

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            do {
                                let jsonobject = try JSONSerialization.data(withJSONObject: json)
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                 approverChangedData = try decoder.decode([ApproverChangedData].self, from: jsonobject)
                                
                            } catch {
                                print(error)
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }

                    self.timeSheetArray[index].wfRequestUINav?.approverChangedData = approverChangedData
                    for item in approverChangedData{
                        if item.label == "Time Type"{
                            self.timeSheetArray[index].timeType = item.newValue ?? ""
                        }else if item.label == "Approval Status"{
                            self.timeSheetArray[index].approvalStatus = item.newValue ?? ""
                        }else if item.label == "Period"{
                            self.timeSheetArray[index].peroid = item.newValue ?? ""
                        }
                    }
                    DispatchQueue.main.async {
                            self.updateUI?()
                        }
                } catch {
                    print(error.localizedDescription)
                }
                self.delegate?.showLoadingIndicator = false
            case .success( _, let message):
                print(message as Any)
                self.delegate?.showLoadingIndicator = false
            }
        })
    }
    }


