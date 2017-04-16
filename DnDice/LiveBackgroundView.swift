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
    }
    
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.backgroundColor = colors.getRandom()
        }
    }
    
    private var timer = Timer()
    func restartAnimations(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    private var isAnimating: Bool = false
    @objc private func timerFired(){
        guard !isAnimating else { return }
        
        let newColor = UIColor.init(gradientStyle: .topToBottom, withFrame: bgView.bounds, andColors: self.gradients.getRandom())
        
        self.isAnimating = true
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseIn, animations: {
            self.topBG.backgroundColor = self.colors.getRandom()
        }) { (completed) in
            self.bgView.backgroundColor = newColor
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseIn, animations: {
                self.topBG.backgroundColor = UIColor.clear
            }){ (completed) in
                self.isAnimating = false
            }
        }
    }
    
    private let colors = [UIColor.flatOrange, UIColor.flatMagenta]
    private let gradients = [[UIColor.flatOrange, UIColor.flatMagenta],[UIColor.flatOrange, UIColor.flatOrange, UIColor.flatMagenta],[UIColor.flatOrange, UIColor.flatMagenta, UIColor.flatMagenta]]
}
