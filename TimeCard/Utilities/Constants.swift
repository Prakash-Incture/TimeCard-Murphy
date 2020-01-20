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

    let clientId = "ZTI5Yjk3OTdlMzM2M2UyZDJlMjRmZjgyOGMyMw"
    let userId = "sfadmin"
    let tokenUrl = "https://api4preview.sapsf.com//oauth/token"
    let privatekay = "TUlJRXZRSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS2N3Z2dTakFnRUFBb0lCQVFERmVKaGJiNnViZm80dVFyeWhpUjhNUTZ3TjJEcE9mMHNLYWVFbUEvem5ZcnRBa3dkRm40cldTdXJpcUs5U2R1K2hvNmF1VDYxRzMrWmcxRjZ6SG5QSE1kQmNjTm8xOG1QNk5pN1VEWmlsUkN3Z1l4aWlDeVZiL0VsTlRtMlVKNG9NQy8yNGRwZGV6TFdMc2xNM1prcEFvMGtmTUM3N0MzeWk5Y2EweHdYVmI3dUU5V2VGbmcyU2gxa3U1R3JYZ2gxUmwrOWZIb3lPOTV2UE5sUHNtdUhPVlNlN0xjR2VMV0RoemZYNGhFbXRzT2NmblRkVzh5WEt5TWh2eXV1cFVuc3E0QkF0QXAzN054VUxiK2trSnhpM21NT1d6YVF6SUswNUlscjdtNWoySFNCc3QyUGc2OURxakVkWFE4Q2MzOFZ4QmNPd29qaE83bUk4NTZ3aHRmOUpBZ01CQUFFQ2dnRUFMMElCRkVEUlRORW9yYUdEQ3hXSnZLR2xWMXJiK1ZVMVhEU2lrVHA3RjlUbEF6c3NqbGowSFB5bzRiMkUxN05tL2NQd2E5N2RsUXlZVWF3QlRkU0gySy92TVhCQWlKQ05wSis2N1R5anYwbGxWZ3JoSmthTWxrcjJMKzRKQTEvREJjY0kzVkJrUVdlME9zNWVZKyt5N1cwbVhyUmxTZWNoMk00QTA5cWRac3ArNlcrUEh3ZG9XMnNlU0JKbmVXWW1wZTdoOWRYSjU5ckdaOGNLSmVOWTZsNkNta0I5T01wN1h0QVVpcDdrVGl5R2FHbWRWRGZVODlLcFVudVMvVTRKd3F3NW8xeXBzbkVLUlh3VmQvVVhtLzlaTVdyR3lNTUhHMUdZNGg2Y3NvSlFGRzMvaG5mL3JoNHAwT0ZRQ0JNNFVDbHI3Wmg3L2NCbm5sb3lacDJBRVFLQmdRRG5OVzAyZlNIOUF6R2s0bVJ2ZXNnSEZBUnRyclp4bm5kQW1uOTlSQmhGaEZ4MXV4eUVaRTVVT1F2cmM5TW1tK3hQdSswd01JTnE1elZhTFhlc29vK0tBcW9ONDBZK01MVUNkR3ZqVFdKdktrT1VHci9Ha0hkclVhQStMc3lRd1k4dWxSM000QVlKZmZ5cGdnd25rTTY4ZzJ4S1N1ZC9rVUozWXEvdmR5YzYyd0tCZ1FEYXBSWU9jK2pwaVRURlNZejdYWXlVVUNpaEpacjRUeWoyU3NJcTNkUEk2ejd1VUxiejBkNjRhaWVDN3UxWjllQXpCakZXZ3lEb0V5MmdMOVZvekIxaUdLUEJaYVJsU2p3aXprY0c0Z1dBZDV1K2RMNERjZzVrbVpzKzRzRVVWTEZyZnpxNW1XdnA3WHBFbVFqVjhJYlBqSHhhaUJDZDN0VUhBekNicm9xOXF3S0JnSDZkNFlzL2g4ZDVZa3g3dHFqZVFvQ3QwNmNGVU9CeitiYWxaVUFDZEpCTlpoMExOUmpEbmFtOSsrc2JhUHp4MHIzdm1uc1Rka1NyRGFxdXo2VDQrVWFKSXZ1c0JTRzFwc3NMV3JJR0JPdi81elpLVjgreitkSUp4NG1HTTN6cW96RE5kSjVuNktaMkdsSHg2Qm9hMFR5bmREeFRQT2U5Y3ZyU1Rxc0RRN2FWQW9HQURyRlJUaDlUNDMybzRpa1RKRUVoRlVaZHRKYUdWM0ZhVzFLaXdhYXVlSzMyU0tWNzVkNlFqT3YxUThNeWgvMFIxOXZ1ck5XYS9IMXRiM3BIYVFkdVlnMHQwKzAwb3VuZUtLaWI5VVp6QURNSmNEOEFGZE13VEdwV0dGKzhnZFUvSnU0aDBCOFROV0VUK2xBZVcrSVI3UmlQc3JXNkNDSFZSdWRiK05vOTBJa0NnWUVBbFNVTXI0WE1FVzF4TGhvbHFTSFBRa2pxdE5jNE9nNmh3WVQvNWpsMjRUTllxaTBqZnJvSkg1NERESW5SeU13cjRicFBBYnpxKzJtbDBXOHl5MTVyWTFaRVVIcjlreXV3RytmSlZKbDRVUWpuRVN2bmZpVHR1TWV5Rk5kU1c0K0x3UDBlYkpIR3N5SnVTZVRjQlE2a2FDeWV3clNOVk1WUUNwK1pNOGUrbWhRPSMjI0MwMDAwMTcxMzU4RA=="
    
     let grantType = "urn:ietf:params:oauth:grant-type:saml2-bearer"
     let companyId = "C0000171358D"
    
    //UserDefaultKeys:
     let accessTokenForTimeSheet = "AccessTokenForTimeSheet"
     let assertionTokenForTimeSheet = "assertionTokenForTimeSheet"
