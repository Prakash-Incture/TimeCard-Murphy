//
//  AbsencesViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import UIKit

class AbsencesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentHeaderCells: [CellModelForAbsence] = AbsenceCurrentPage.absenceRecording.getCurrentPageHeaders()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Absences"
        self.customNavigationType = .navWithBack
        setupTableViewConfigur()
    }
    func setupTableViewConfigur(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRecordTableViewCell")
        self.tableView.register(UINib(nibName: "GenericTableviewDropdownCell", bundle: nil), forCellReuseIdentifier: "GenericTableviewDropdownCell")

    }
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AbsencesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentHeaderCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
        let cellModel = currentHeaderCells[indexPath.row]
        cell.contentLbl.text = cellModel.absenceModelIdentifier.rawValue
        switch cellModel.absenceModelIdentifier {
        case .timeType:
            cell.arrowImageView.isHidden = false
            cell.valueLabel.text = cellModel.absenceModelIdentifier.dataForSelection.first
            break
            case .availableBalance:
                cell.arrowImageView.isHidden = true
                cell.valueLabel.text = "24"
            break
            case .startDate:
                cell.arrowImageView.isHidden = false
            break
            case .endDate:
                cell.arrowImageView.isHidden = false
            break
        case .requesting:
            cell.arrowImageView.isHidden = false
            cell.valueLabel.text = "Days/Hours"
            break

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = currentHeaderCells[indexPath.row]

        switch cellModel.absenceModelIdentifier {
        case .timeType:
            guard let listVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else { return }
            listVC.list = cellModel.absenceModelIdentifier.dataForSelection
            listVC.sendData = {
                
            }
            self.navigationController?.pushViewController(listVC, animated: true)
                      break
        case .availableBalance:
            
                      break
        case .startDate:
                      break
        case .endDate:
                      break
        case .requesting:
            break
        }
    }

}
