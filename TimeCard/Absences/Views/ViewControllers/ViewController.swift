//
//  ViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 31/12/19.
//  Copyright © 2019 Naveen Kumar K N. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = homeScreenTitle
        self.customNavigationType = .navPlain
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configurTableView()
    }
    func configurTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
          self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
   @objc func newRecordBtnClicked(sender:UIButton){
        let storyBoard = UIStoryboard(name: "AllocationHours", bundle: nil)
        let newRecordVC = storyBoard.instantiateViewController(withIdentifier: "NewRecordingViewController") as! NewRecordingViewController
        self.navigationController?.pushViewController(newRecordVC, animated: true)
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.newRecordingBtn.addTarget(self, action: #selector(newRecordBtnClicked), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
