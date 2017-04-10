//
//  LiveBackgroundView.swift
//  DnDice
//
//  Created by John Raymund Catahay on 11/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import ChameleonFramework

class LiveBackgroundView: BaseView {
    
    @IBOutlet weak var topBG: UIVisualEffectView!
    override func initialize() {
        super.initialize()
        xibSetup(nibName: "LiveBackgroundView")
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true).fire()
    }
    
    @objc private func timerFired(){
        let newColor = UIColor.init(gradientStyle: .topToBottom, withFrame: CGRect(x: 0, y: 0, width: self.bgView.frame.width, height: self.bgView.frame.height * 1.3), andColors: self.gradients.getRandom())
        UIView.animate(withDuration: 1.5, animations: {
            self.topBG.backgroundColor = self.colors.getRandom()
        }, completion: { completed in
            self.bgView.backgroundColor = newColor
            UIView.animate(withDuration: 2.5, animations: {
                self.topBG.backgroundColor = UIColor.clear
            }, completion: nil)
        })
    }
    
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.backgroundColor = UIColor.init(gradientStyle: .topToBottom, withFrame: CGRect(x: 0, y: 0, width: bgView.frame.width, height: bgView.frame.height * 1.3), andColors: self.gradients[0])
        }
    }
    
    let colors = [UIColor.flatOrange, UIColor.flatMagenta]
    
    let gradients = [[UIColor.flatOrange, UIColor.flatMagenta],[UIColor.flatOrange, UIColor.flatOrange, UIColor.flatMagenta],[UIColor.flatOrange, UIColor.flatMagenta, UIColor.flatMagentaDark]]
}
