//
//  Constants.swift
//  TimeCard
//
//  Created by Naveen Kumar K N on 31/12/19.
//  Copyright © 2019 Naveen Kumar K N. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Base URL's
#if DEV
// DEV URL
let baseURL = ""
#elseif QA
// QA URL
let baseURL = ""
#elseif RELEASE_PRODUCTION
 // Production URL
let baseURL = ""
#endif

struct K {
    struct ServerURL {
        static let serverbaseURL = baseURL
    }
}

//MARK:- App Delegate Object
let APP_DELEGATE : AppDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK:- String Constants

let homeScreenTitle = "Time Card"
let newRecordingScreenTitile = "New Recording"

//MARK:- Color Constants
enum Color{
    case theme

    // 1
    case custom(hexString: String, alpha: Double)
    // 2
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }

    var value: UIColor {
        var instanceColor = UIColor.clear

        switch self {
        case .theme:
            instanceColor = UIColor(hexString: "#01265A")
        case .custom(let hexString, let alpha):
            print(hexString)
            print(alpha)
            break
        }
        return instanceColor
    }
}
