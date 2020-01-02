//
//  Extensions.swift
//  TimeCard
//
//  Created by prakash on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
