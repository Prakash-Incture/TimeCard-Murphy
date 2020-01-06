//
//  BaseViewController.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 31/12/19.
//  Copyright © 2019 Naveen Kumar K N. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
   var navigationType  : CustomNavType           = .navPlain

    var customNavigationType : CustomNavType {
          
          get {
              return self.navigationType
          }
          set (customNavigationType) {
              
              self.navigationType = customNavigationType
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .bold)]
              switch customNavigationType {
              case .navWithBack:
                  let backBtn =  NavBackButton(type: .custom)
                  backBtn.addTarget(self, action: #selector(selectedBack(sender:)), for: .touchUpInside)
                  navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
                  navigationItem.rightBarButtonItem = nil
                  break
              case .navPlain:
                  self.navigationItem.setHidesBackButton(true, animated:true)
                  navigationItem.leftBarButtonItem = nil
                  navigationItem.rightBarButtonItem = nil
                  break
              case .navWithLefttittle:
                    let titleBtn =  NavLeftTitleButton(type: .custom)
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleBtn)
                    navigationItem.rightBarButtonItem = nil
                  break
              case .navWithSaveandCancel:
                let cancelBtn =  NavCancelButton(type: .custom)
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
                cancelBtn.addTarget(self, action: #selector(selectedCancel(sender:)), for: .touchUpInside)

                let saveBtn = NavsaveButton(type: .custom)
                    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
                    saveBtn.addTarget(self, action: #selector(selectedSave(sender:)), for: .touchUpInside)
                break
              case .navWithBackandDone:
                    let backBtn =  NavBackButton(type: .custom)
                        backBtn.addTarget(self, action: #selector(selectedBack(sender:)), for: .touchUpInside)
                        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
                    let doneBtn = NavDoneButton(type: .custom)
                        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
                        doneBtn.addTarget(self, action: #selector(selectedDone(sender:)), for: .touchUpInside)
                break
              case .navBackWithAction:
                    let backBtn =  NavBackButton(type: .custom)
                                 backBtn.addTarget(self, action: #selector(selectedBack(sender:)), for: .touchUpInside)
                                 navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
                        let actionBtn = NavActionButton(type: .custom)
                                 navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionBtn)
                                 actionBtn.addTarget(self, action: #selector(selectedAction(sender:)), for: .touchUpInside)
              case .naveBackWithPaste:
                let backBtn =  NavBackButton(type: .custom)
                         backBtn.addTarget(self, action: #selector(selectedBack(sender:)), for: .touchUpInside)
                         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
                let pasteBtn = NavPasteButton(type: .custom)
                         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pasteBtn)
                         pasteBtn.addTarget(self, action: #selector(selectedPaste(sender:)), for: .touchUpInside)
            }
          }
      }
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    }
    
    //MARK:- Custom Navigation Back Button action
    @objc func selectedBack(sender: UIButton) {
          DLog(message: "Overide")
        }
    @objc func selectedSave(sender: UIButton) {
             DLog(message: "Overide")
         }
    @objc func selectedCancel(sender: UIButton) {
             DLog(message: "Overide")
         }
    @objc func selectedDone(sender: UIButton) {
              DLog(message: "Overide")
          }
    @objc func selectedAction(sender: UIButton) {
                DLog(message: "Overide")
            }
    @objc func selectedPaste(sender: UIButton) {
                 DLog(message: "Overide")
             }
}
