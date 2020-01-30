//
//  ListViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit
import SAPFiori
class ListViewController: BaseViewController,SAPFioriLoadingIndicator {

    @IBOutlet weak var tableView: UITableView!
    var list = [String]()
    var sendData : ((TimeType)->())?
    weak var delegate:UpdateData?
    var absenseData = [AvailableTimeData]()
    var userData:UserData?
    lazy var requestManger = RequestManager<TimeAndAbsenceLookUp>()
    var loadingIndicator: FUILoadingIndicatorView?
    var showLoadingIndicator: Bool? {
        didSet {
            if showLoadingIndicator == true {
                self.showFioriLoadingIndicator("Loding")
            } else {
                self.hideFioriLoadingIndicator()
            }
        }
    }
       override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Absences"
        self.customNavigationType = .navWithBack
       // self.absenseData = self.absenseData?.filter({$0.timeTypeNav?.timeType?.category == "ABSENCE"})
        self.setupTableViewConfigur()
        self.timeandAbsenseLookUpCalling()
       }
    func setupTableViewConfigur(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
}

extension ListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.absenseData.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let data = self.absenseData[indexPath.row]
        cell.contentLbl.text = data.timeTypeNav?.timeType?.externalName_en_US
        cell.cellTextField.isHidden = true
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.sendData?()
        let data = self.absenseData[indexPath.row]
        self.sendData?((data.timeTypeNav?.timeType)!) //self.delegate?.updateValue(value:data?.timeTypeNav?.timeType?.externalName_en_US)
         self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}

extension ListViewController{
    func timeandAbsenseLookUpCalling(){
        SDGEProgressView.startLoader("")
         self.requestManger.fetchlookUpdata(for:userData ?? UserData(), completion: { [weak self] result in
             guard let self = self else { return }
             switch result {
             case .failure(let message):
                print("\(message)")
                self.showLoadingIndicator = false
                DispatchQueue.main.async {
                    SDGEProgressView.stopLoader()
                }
                break
             case .success(let value, let message):
               // self.absenseData = value?.availableTimeType?.availableTimeType?.filter({$0.timeTypeNav?.timeType?.category == "ABSENCE" && $0.enabledInEssScenario == "true"})
              
                 print(message as Any)
                 self.showLoadingIndicator = false
             case .successData(let value):
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: value, options: .allowFragments)
                    let data = jsonObject as? [String:Any]
                    let availableTimeType = data?["AvailableTimeType"] as? [String:Any]
                    let availTimeType = availableTimeType?["AvailableTimeType"] as? [[String:Any]]
                    var absenceLookUp = TimeAndAbsenceLookUp()
                    var absenceLookUpData = AvailableTimeType()
                    var absenceDataValues = [AvailableTimeData]()
                    
                    for item in availTimeType ?? []{
                        var  obj = AvailableTimeData()
                        obj.enabledInEssScenario = item["enabledInEssScenario"] as? String
                        var timeTypeNavObj = TimeTypeNav()
                        var timeTypeObj = TimeType()
                        
                        let timedata = item["timeTypeNav"] as? [String:Any]
                        let timeDataValue = timedata?["TimeType"] as? [String:Any]
                        timeTypeObj.category = timeDataValue?["category"] as? String
                        timeTypeObj.externalCode = timeDataValue?["externalCode"] as? String
                        timeTypeObj.externalName_en_US = timeDataValue?["externalName_en_US"] as? String
                        if timeDataValue?["timeAccountPostingRules"] is Dictionary<AnyHashable,Any>{
                            let data = timeDataValue?["timeAccountPostingRules"] as? [String:Any]
                            let timeAccountPostingRulesData = data?["TimeAccountPostingRule"] as? [String:Any]
                            var timeAccountPostingRules = TimeAccountPostingRules()
                            var timeAccountPostingRuleData = TimeAccountPostingRuleData()
                            timeAccountPostingRules.TimeAccountPostingRule = timeAccountPostingRuleData
                            timeAccountPostingRuleData.timeAccountType = timeAccountPostingRulesData?["timeAccountType"] as? String
                            timeAccountPostingRuleData.TimeType_externalCode = timeAccountPostingRulesData?["TimeType_externalCode"] as? String
                            timeAccountPostingRules.TimeAccountPostingRule = timeAccountPostingRuleData
                            timeTypeObj.timeAccountPostingRules = timeAccountPostingRules
                        }
                        timeTypeNavObj.timeType = timeTypeObj
                        obj.timeTypeNav = timeTypeNavObj
                        absenceDataValues.append(obj)
                    }
                    absenceLookUpData.availableTimeType = absenceDataValues
                    absenceLookUp.availableTimeType = absenceLookUpData
                    self.absenseData = absenceLookUp.availableTimeType?.availableTimeType?.filter({(($0.timeTypeNav?.timeType?.category == "ABSENCE") && ($0.enabledInEssScenario == "true"))}) ?? []
                    DispatchQueue.main.async {
                            self.tableView.reloadData()
                            SDGEProgressView.stopLoader()
                }
                }catch(let error){
                    print(error)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        SDGEProgressView.stopLoader()
                    }
                }
                
                
                break
                 // get Success data here
             }
         })
     }
}
