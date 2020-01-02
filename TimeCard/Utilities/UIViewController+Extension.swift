//
//  UIViewController+Extension.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 31/12/19.
//  Copyright © 2019 Naveen Kumar K N. All rights reserved.
//

import Foundation
import UIKit

enum CustomNavType :String{
    case navWithLefttittle
    case navPlain
    case navWithBack
    case navWithSaveandCancel
    case navWithBackandDone
    case navBackWithAction
    case naveBackWithPaste
}

class NavLeftTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Time Card", for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavsaveButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Save", for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavCancelButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Cancel", for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavPasteButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Cancel", for: .normal)
        let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .black)
        let pasteImage = UIImage(systemName: "doc.on.doc", withConfiguration: homeSymbolConfiguration)
        self.setImage(pasteImage, for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavActionButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Action", for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavDoneButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("Done", for: .normal)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0)
    }
}
class NavBackButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .black)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: homeSymbolConfiguration)

       self.setImage(backImage, for: .normal)
        self.contentMode = .center
    }
}

class NavDeleteButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setImage(UIImage(named: "delete"), for: .normal)
        self.tintColor = .white
    }
}

func DLog( message: @autoclosure () -> String, filename: String = #file, function: String = #function, line: Int = #line){
    #if DEV || QA
        let lastPathComponent = (filename as NSString).lastPathComponent
        NSLog("\(lastPathComponent):\(line): \(function): %@", message())
    #endif
}


extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format

     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x0000_00FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
