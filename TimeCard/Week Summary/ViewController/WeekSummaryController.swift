//
//  WeekSummaryController.swift
//  TimeCard
//
//  Created by prakash on 06/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class WeekSummaryController: UIViewController {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!

    //Variables
    var currentPage: CurrentPage = CurrentPage.weekSummary
    var currentHeaderCells: [[CellModel]] = CurrentPage.weekSummary.getCurrentPageHeaders()
    var allocationViewModel:AllocationDataViewModel?
    var stringHelper = StringColorChnage()
    var showLoadingIndicator: Bool? {
              didSet {
                  if showLoadingIndicator == true {
                   //   self.showFioriLoadingIndicator("Syncing Data")
                  } else {
                     // self.hideFioriLoadingIndicator()
                  }
              }
          }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allocationViewModel = AllocationDataViewModel(delegate: self)
        self.allocationViewModel?.dataFetching()
        self.setUpNavigation()
    }
    func setUpNavigation(){
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "AllocatedTimeTableCell", bundle: nil), forCellReuseIdentifier: "AllocatedTimeTableCell")
        self.tableView.register(UINib(nibName: "WeekSummaryCell", bundle: nil), forCellReuseIdentifier: "WeekSummaryCell")
        let filterItem = UIBarButtonItem.init(title:"Action", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onTapofAction))
        navigationItem.rightBarButtonItem = filterItem
        self.navigationItem.title = "Week Summary"
    }
}
// MARK: - Table view data source
extension WeekSummaryController:UITableViewDelegate,UITableViewDataSource{
   func numberOfSections(in tableView: UITableView) -> Int {
    return currentHeaderCells.count
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0{
    return currentHeaderCells[section].count
     }
    return (self.allocationViewModel?.allcationModelData.weekData?.count ?? 0)
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0{
        let cellModel = currentHeaderCells[indexPath.section][indexPath.row] as CellModel
        switch cellModel.reuseIdentifier {
        case .WeekSummaryCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? WeekSummaryCell else { fatalError("Textfield cell not found") }
            cell.setModel(cellModel)
            cell.allocationData = self.allocationViewModel?.allcationModelData
            cell.selectionStyle = .none
            cell.allocationData = self.allocationViewModel?.allcationModelData
            return cell
        case .AllocatedTimeTableCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? AllocatedTimeTableCell else { fatalError("Textfield cell not found") }
            cell.allocationViewModel = self.allocationViewModel
            return cell
        case .GenericTableviewDropdownCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"GenericTableviewDropdownCell") as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            return cell
        }
      }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"WeekSummaryCell") as? WeekSummaryCell else { fatalError("Textfield cell not found") }
             let tempVal = self.allocationViewModel?.allcationModelData.weekData?[indexPath.row]
             cell.titleText.text = "\(tempVal?.day ?? "")\n\(tempVal?.date ?? "")"
            cell.labelData.attributedText = stringHelper.conevrtToAttributedString(firstString: tempVal?.hours ?? "", secondString: " Hours", firstColor: cell.titleText.textColor, secondColor: UIColor.lightGray)
             return cell
        }
   }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           if section == 0{
               let _: CGRect = tableView.frame
               let headerView = (Bundle.main.loadNibNamed("Headercell", owner: self, options: nil)?[1] as? WeekHaderCell)
               headerView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
               return headerView
           }
           return nil
       }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }
        return 30
    }
 }
extension WeekSummaryController{
    @objc func onTapofAction() {
          let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
          
          let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) -> Void in
          })
          
          let saveDraft = UIAlertAction(title: "Save Draft", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)

          })
          let submit = UIAlertAction(title: "Submit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
          })
          
          cancel.setValue(UIColor.red, forKey: "titleTextColor")
          saveDraft.setValue(UIColor.black, forKey: "titleTextColor")
          submit.setValue(UIColor.blue, forKey: "titleTextColor")
          
          alertController.addAction(cancel)
          alertController.addAction(saveDraft)
          alertController.addAction(submit)
          
          self.present(alertController, animated: true, completion: nil)
          
       }
}
extension WeekSummaryController:GenericViewModelProtocol{
    func failedWithReason(message: String) {
        self.showAlert(message: message)
    }
    
    func didReceiveResponse() {
        self.tableView.reloadData()
    }
}
