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
    var absenseData:[AvailableTimeData]?
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
        return (self.absenseData?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let data = self.absenseData?[indexPath.row]
        cell.contentLbl.text = data?.timeTypeNav?.timeType?.externalName_en_US
        cell.cellTextField.isHidden = true
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.sendData?()
        let data = self.absenseData?[indexPath.row]
        self.sendData?((data?.timeTypeNav?.timeType)!) //self.delegate?.updateValue(value:data?.timeTypeNav?.timeType?.externalName_en_US)
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
                self.absenseData = value?.availableTimeType?.availableTimeType?.filter({$0.timeTypeNav?.timeType?.category == "ABSENCE"})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SDGEProgressView.stopLoader()
                }
                 print(message as Any)
                 self.showLoadingIndicator = false
             case .successData( _): break
                 // get Success data here
             }
         })
     }
}
