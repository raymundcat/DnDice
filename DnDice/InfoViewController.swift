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
            logoImageView.tintColor = .sunset()
            logoImageView.image = #imageLiteral(resourceName: "d20").withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBAction func didSwipeDown(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressTwitter(_ sender: Any) {
        
    }
    
    @IBAction func didPressX(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

let screenName = "raymundcat"

let authorMessage = "i hope that you are finding this app useful and enjoying.\n\n\nfeeling generous with a review?"
