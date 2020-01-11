//
//  Extensions.swift
//  TimeCard
//
//  Created by prakash on 02/01/20.
//  Copyright © 2020 Naveen Kumar K N. All rights reserved.
//

import Foundation
import UIKit
import SAPFiori
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
               secondStringValues = ""
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
protocol SAPFioriLoadingIndicator: class {
    var loadingIndicator: FUILoadingIndicatorView? { get set }
}

extension SAPFioriLoadingIndicator where Self: UIViewController {

    func showFioriLoadingIndicator(_ message: String = "") {
        OperationQueue.main.addOperation({
            let indicator = FUILoadingIndicatorView(frame: self.view.frame)
            indicator.text = message
            self.view.addSubview(indicator)
            indicator.show()
            self.loadingIndicator = indicator
        })
    }

    func hideFioriLoadingIndicator() {
        OperationQueue.main.addOperation({
            guard let loadingIndicator = self.loadingIndicator else {
                return
            }
            loadingIndicator.dismiss()
        })
    }
}
extension Date {

enum DateFormat: String {
    //        case yearMonthDateBarSeparator = "MM-dd-yyyy"
    case yearMonthDateHypenSeparator = "YYYY-MM-dd"
    case monthDateYearHiphenSeparator = "MM-dd-yyyy"
    case monthDateYearSlashSeperator = "MM/dd/yyyy"
    case long = "yyyy-MM-dd HH:mm:ss"
    case monthDateYearLong = "MM-dd-yyyy HH:mm:ss"
    case dayMonthYear = "dd MMM yyyy"
    case short = "hh:mm a"
    case hourMinuteSeconds = "HH:mm:ss"
    case hourMinuteSeconds12Hour = "hh:mm:ss a"
    case dayMonthYearwithTime = "dd, MMM yyyy hh:mm a"
    case yearMonthDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    case monthDateYearTime = "MMM dd, yyyy h:mm:ss a"
   case  monthDateSingledayTime = "MMM d, yyyy h:mm:ss a"

}
    func toDateFormat(_ format: DateFormat, isUTCTimeZone: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        if isUTCTimeZone {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
}