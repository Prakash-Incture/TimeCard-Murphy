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
    func updateValue(value:String?,id:String)
}
class AllocationTimeTypeController: BaseViewController,SAPFioriLoadingIndicator {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableViewConstant: NSLayoutConstraint!
    
    var timeType:[AvailableTimeData]?
    var allocationData:AllocationModel?
    weak var delegate:UpdateData?
    var cellType: AllocationCellIdentifier?
    var costcenterData : [CostCenterDataModel]?
    var costCenterSerachData:[CostCenterDataModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
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
        self.tableViewConstant.constant = self.title == "Cost Center" ? 44 : 0
        self.getData()
        self.tableView.tableFooterView = UIView()
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
            if searchBar.text != ""{
             return costCenterSerachData?.count ?? 0
            }else{
                 return costcenterData?.count ?? 0
            }
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
                if costCenterSerachData?.count != nil{
                    let data = self.costCenterSerachData?[indexPath.row]
                    cell.contentLbl.text = data?.externalName ?? ""
                    cell.cellTextField.isUserInteractionEnabled = false
                    cell.cellTextField.text = data?.cust_Costcenter ?? ""
                    cell.accessoryType = .none
                }else{
                    let data = self.costcenterData?[indexPath.row]
                    cell.contentLbl.text = data?.externalName ?? ""
                    cell.cellTextField.isUserInteractionEnabled = false
                    cell.cellTextField.text = data?.cust_Costcenter ?? ""
                    cell.accessoryType = .none
                }
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
            delegate?.updateValue(value:timeTypeData?.timeTypeNav?.timeType?.externalName_en_US  ?? "", id: timeTypeData?.timeTypeNav?.timeType?.externalCode ?? "")
            self.navigationController?.popViewController(animated: true)
            return
        case .costCenter:
            if costCenterSerachData?.count != nil{
                let data = self.costCenterSerachData?[indexPath.row]
                delegate?.updateValue(value:data?.externalName ?? "", id: data?.cust_Costcenter ?? "")
                self.navigationController?.popViewController(animated: true)
            }else{
                let data = self.costcenterData?[indexPath.row]
                delegate?.updateValue(value:data?.externalName ?? "", id: data?.cust_Costcenter ?? "")
                self.navigationController?.popViewController(animated: true)
            }
            return
        default: return
        }
       
    }
}
extension AllocationTimeTypeController{
    func getData(){
        switch self.cellType {
        case .timeType:
            SDGEProgressView.startLoader("")
            self.requestManger.fetchlookUpdata(for:userData ?? UserData(), completion: { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .failure(let message):
                      self.showLoadingIndicator = false
                      DispatchQueue.main.async {
                        SDGEProgressView.stopLoader()
                      }
                    print(message)
                  case .success(let value, let message):
                      print(message as Any)
                      self.timeType = value?.availableTimeType?.availableTimeType
                      self.timeType = self.timeType?.filter({$0.timeTypeNav?.timeType?.category == "ATTENDANCE"})

                      DispatchQueue.main.async {
                            self.tableView.reloadData()
                        SDGEProgressView.stopLoader()
                      }
                      self.showLoadingIndicator = false
                  case .successData( _): break
                      // get Success data here
                  }
              })
            
            break
        case .costCenter:
            SDGEProgressView.startLoader("")
               self.costCenter.costCenterAPIcall(for: userData ?? UserData(), completion: { [weak self] result in
                   guard let self = self else { return }
                   switch result {
                   case .failure(let message):
                    DispatchQueue.main.async {
                        SDGEProgressView.stopLoader()
                    }
                       self.showLoadingIndicator = false
                   case .success(let value, let message):
                       print(message as Any)
                       self.costcenterData = value?.cust_WBS_Element_Test?.cust_WBS_Element_Test ?? [CostCenterDataModel]()
                       DispatchQueue.main.async {
                        self.tableView.reloadData()
                        SDGEProgressView.stopLoader()
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

extension AllocationTimeTypeController:UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearch(searchText: searchBar.text!)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearch(searchText: searchBar.text!)
        //        timer = Timer.scheduledTimer(timeInterval: 03, target: self, selector: #selector(update), userInfo: nil, repeats: true)

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    func onSearch(searchText : String){
        self.costCenterSerachData = searchText.isEmpty ? self.costcenterData : self.costcenterData?.filter({ costSearch -> Bool in
            // If dataItem matches the searchText, return true to include it
            guard let costNumber = costSearch.cust_Costcenter, let owner = costSearch.externalName else { return false }
            return costNumber.range(of: searchText, options: .caseInsensitive) != nil || owner.range(of: searchText, options: .caseInsensitive) != nil
        })
    }
}
