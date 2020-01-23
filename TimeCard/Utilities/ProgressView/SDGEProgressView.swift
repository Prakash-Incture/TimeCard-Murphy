//
//  SDGEProgressView.swift
//  SDGE Near Miss
//
//  Created by Naveenkumar.KN on 15/10/19.
//  Copyright © 2019 Incture. All rights reserved.
//

import UIKit

@objc class SDGEProgressView: UIView {
    
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var progressImg: UIImageView!
    
    static let ProgressLoaderView : SDGEProgressView = UINib(nibName: "SDGEProgressView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SDGEProgressView
    
    class func startLoader(_ text: String) {
        let progressView: SDGEProgressView? = self.ProgressLoaderView
    let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
        progressView?.progressImg.image = progressView?.progressImg.image?.withRenderingMode(.alwaysTemplate)
        progressView?.progressImg.tintColor = .white
        progressView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: ((mainWindow.frame.size.width)), height: ((mainWindow.frame.size.height)))
        mainWindow.addSubview(progressView!)
        var rotationAnimation: CABasicAnimation?
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation?.toValue = Int(.pi * 2.0 * 2 * 0.6)
        rotationAnimation?.duration = 1
        rotationAnimation?.isCumulative = true
        rotationAnimation?.repeatCount = MAXFLOAT
        progressView?.textLable.text = text
        progressView?.progressImg?.layer.add(rotationAnimation!, forKey: "rotationAnimation")
    }
    
    class func stopLoader() {
        let progressView: SDGEProgressView? = ProgressLoaderView
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            progressView?.alpha = 0
        }, completion: {(_ finished: Bool) -> Void in
            progressView?.removeFromSuperview()
            progressView?.alpha = 1
        })
    }
}
