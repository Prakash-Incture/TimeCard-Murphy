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
class StringColorChnage{
    func conevrtToAttributedString(firstString:String,secondString:String,firstColor:UIColor,secondColor:UIColor) -> NSMutableAttributedString{
           var secondStringValues = secondString
           if secondString.count < 1{
               secondStringValues = "--"
           }
           let attributedStringOne = NSAttributedString(string:firstString,
                                                        attributes:[NSAttributedString.Key.foregroundColor: firstColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17) as Any])
           let attributedStringTwo = NSAttributedString(string:secondStringValues,
                                                        attributes:[NSAttributedString.Key.foregroundColor: secondColor,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17) as Any])
           let finalString = NSMutableAttributedString()
           finalString.append(attributedStringOne)
           finalString.append(attributedStringTwo)
           
           return finalString
}
}
