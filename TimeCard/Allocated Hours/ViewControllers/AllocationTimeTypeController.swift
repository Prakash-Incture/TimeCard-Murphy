//
//  AllocationTimeTypeController.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import UIKit
import SAPFiori

protocol UpdateData:class {
    func updateValue(value:String?)
}
class AllocationTimeTypeController: BaseViewController,SAPFioriLoadingIndicator {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewConstant: NSLayoutConstraint!
    
    var timeType:[AvailableTimeData]?
    var allocationData:AllocationModel?
    weak var delegate:UpdateData?
    var cellType: AllocationCellIdentifier?
    var costcenterData : [CostCenterDataModel]?
    var userData:UserData?
    lazy var costCenter = RequestManager<CostCenterData>()
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
        // Do any additional setup after loading the view.
        self.customNavigationType = .navWithBack
        self.title = self.cellType?.rawValue
        self.getData()
        self.tableView.tableFooterView = UIView()
        self.tableViewConstant.constant = 0
        self.timeType = self.timeType?.filter({$0.timeTypeNav?.timeType?.category == "ATTENDANCE"})
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")

    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AllocationTimeTypeController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellType {
        case .timeType:
            return timeType?.count ?? 0
        case .costCenter:
             return costcenterData?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .timeType:
                 let cell  = UITableViewCell(style:.default, reuseIdentifier: "Cell")
               let timeTypeData = timeType?[indexPath.row]
               cell.textLabel?.text =
                   timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? ""
                return cell
        case .costCenter:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
                let data = self.costcenterData?[indexPath.row]
                cell.contentLbl.text = data?.externalName ?? ""
                cell.cellTextField.isUserInteractionEnabled = false
                cell.cellTextField.text = data?.cust_Costcenter ?? ""
                cell.accessoryType = .none
                return cell
        default:
            let cell  = UITableViewCell(style:.default, reuseIdentifier: "Cell")
               let timeTypeData = timeType?[indexPath.row]
               cell.textLabel?.text =
                   timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? ""
                return cell
        }
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeTypeData = timeType?[indexPath.row]
        guard let type = cellType else { return }
        switch type {
        case .timeType:
            delegate?.updateValue(value:timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? "")
            self.navigationController?.popViewController(animated: true)
            return
        case .costCenter:
            let data = self.costcenterData?[indexPath.row]
            delegate?.updateValue(value:data?.externalName ?? "")
            self.navigationController?.popViewController(animated: true)
            return
        default: return
        }
       
    }
}
extension AllocationTimeTypeController{
    func getData(){
        switch self.cellType {
        case .timeType:
            self.showLoadingIndicator = true
              self.requestManger.fetchlookUpdata(for:userData ?? UserData(), completion: { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .failure(let message):
                      self.showLoadingIndicator = false
                    print(message)
                  case .success(let value, let message):
                      print(message as Any)
                      self.timeType = value?.availableTimeType?.availableTimeType
                      DispatchQueue.main.async {
                            self.tableView.reloadData()
                      }
                      self.showLoadingIndicator = false
                  case .successData( _): break
                      // get Success data here
                  }
              })
            
            break
        case .costCenter:
            self.showLoadingIndicator = true
               self.costCenter.costCenterAPIcall(for: userData ?? UserData(), completion: { [weak self] result in
                   guard let self = self else { return }
                   switch result {
                   case .failure(let message):
                       self.showLoadingIndicator = false
                   case .success(let value, let message):
                       print(message as Any)
                       self.costcenterData = value?.cust_WBS_Element_Test?.cust_WBS_Element_Test ?? [CostCenterDataModel]()
                       DispatchQueue.main.async {
                        self.tableView.reloadData()
                       }
                    self.showLoadingIndicator = false
                   case .successData( _): break
                       // Get success data here
                   }
               })
            break
        default:
            break
        }
    }
}

