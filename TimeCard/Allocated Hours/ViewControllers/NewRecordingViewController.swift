//
//  ViewController.swift
//  TimeSheetManagement
//
//  Created by prakash on 31/12/19.
//  Copyright © 2019 prakash. All rights reserved.
//

import UIKit

class NewRecordingViewController: UIViewController {
    //UI Compnents
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var currentHeaderCells: [[CellModel]] = CurrentPage.newRecording.getCurrentPageHeaders()

    var HeaderCellsTable = AllocationHeader.getAbsenceCells()
    var currentPage: CurrentPage = CurrentPage.newRecording
    var allocationDataViewModel:AllocationDataViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupViewModel()
        self.setupTableView()
        
    }
    private func setupViewModel() {
        self.allocationDataViewModel = AllocationDataViewModel(delegate: self)
        self.allocationDataViewModel.dataFetching()
       }
    override func viewWillAppear(_ animated: Bool) {
        self.allocationDataViewModel.delegate = self
    }
    func setupTableView() {
           self.tableView.tableFooterView = UIView()
           self.tableView.register(UINib(nibName: "GenericTableviewDropdownCell", bundle: nil), forCellReuseIdentifier: "GenericTableviewDropdownCell")
         self.tableView.register(UINib(nibName: "AllocatedTimeTableCell", bundle: nil), forCellReuseIdentifier: "AllocatedTimeTableCell")
       }
}
//TableView delegates
extension NewRecordingViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentHeaderCells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentHeaderCells[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = currentHeaderCells[indexPath.section][indexPath.row] as CellModel
        switch cellModel.reuseIdentifier {
        case .GenericTableviewDropdownCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? GenericTableviewDropdownCell else { fatalError("Textfield cell not found") }
            cell.setModel(cellModel)
            cell.selectionStyle = .none
            cell.parent = self
            cell.allocationData = self.allocationDataViewModel.allcationModelData.alllocationModel?[indexPath.row] ?? AllocationModel()
            return cell
        case .AllocatedTimeTableCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier.rawValue) as? AllocatedTimeTableCell else { fatalError("Textfield cell not found") }
            cell.allocationDataArray = self.allocationDataViewModel?.allcationModelData.alllocationModel ?? []
            cell.allocationViewModel = self.allocationDataViewModel
            cell.parent = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.currentPage.titleForHeaderInSection(section: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CGFloat((self.allocationDataViewModel.allcationModelData.alllocationModel?.count ?? 230) * 230)
        }
        return 60
    }
   
    @objc func allocatedHoursAction(){
      
        self.tableView.reloadData()
    }
}
extension NewRecordingViewController: GenericViewModelProtocol {
    
    func didReceiveResponse() {
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
}
