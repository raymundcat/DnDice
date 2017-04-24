//
//  InfoViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 09/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import ChameleonFramework

class InfoViewController: BaseViewController {
    
    @IBOutlet weak var messageLabel: UILabel!{
        didSet{
            messageLabel.text = authorMessage
        }
    }
    
    @IBOutlet weak var logoImageView: UIImageView!{
        didSet{
            logoImageView.tintColor = .sunset
            logoImageView.image = #imageLiteral(resourceName: "d20").withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressReview(_ sender: Any) {
        rateApp(appId: appID, completion: nil)
    }
    
    @IBAction func didPressX(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

func rateApp(appId: String, completion: ((_ success: Bool)->())?) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
        completion?(false)
        return
    }
    guard #available(iOS 10, *) else {
        completion?(UIApplication.shared.openURL(url))
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
}

let authorMessage = "i hope that you are finding this app useful and enjoying."
let appID = "id1225043908"

