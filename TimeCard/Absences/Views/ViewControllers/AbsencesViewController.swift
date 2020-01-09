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
    let absenceViewModel = AbsenceViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Absences"
        self.customNavigationType = .navWithBack
    }
    
    override func selectedBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AbsencesViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewRecordTableViewCell", for: indexPath) as! NewRecordTableViewCell
//        switch self.absenceViewModel.absenceModelIdentifier {
//        case .timeType:
//            case .timeType:
//                      <#code#>
//            case .availableBalance:
//                      <#code#>
//            case .startDate:
//                      <#code#>
//            case .endDate:
//                      <#code#>
//        default:
//            <#code#>
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}
