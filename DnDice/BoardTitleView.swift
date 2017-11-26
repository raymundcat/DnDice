//
//  BoardTitleView.swift
//  DnDice
//
//  Created by John Raymund Catahay on 09/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring

class BoardTitleView: BaseView {
    
    @IBOutlet weak private(set) var imageView: UIImageView!
    @IBOutlet weak private(set) var titleLabel: SpringLabel!
    
    var total: Int = 0 {
        didSet{
            resetTimer()
        }
    }
    
    var greetings = [""]
    
    override func initialize() {
        super.initialize()
        xibSetup(nibName: "BoardTitleView")
        self.resetTimer()
    }
    
    private var timer = Timer()
    private func resetTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFired(timer:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc internal func timerFired(timer: Timer){
        guard let message = self.message else {
            self.message = DiceMessage.TotalMessage(prefix: "total:", total: total)
            return
        }
        
        switch message {
        case .Greetings:
            self.message = DiceMessage.TotalMessage(prefix: "total:", total: self.total)
            break
        case .TotalMessage(let prefix, let total):
            if total != self.total{
                self.message = DiceMessage.TotalMessage(prefix: prefix, total: self.total)
            }else{
                if greetings.count > 0 {
                    self.message = DiceMessage.Greetings(message: self.greetings.getRandom())
                }
            }
            break
        }
    }
    
    private var message: DiceMessage?{
        didSet{
            guard let message = self.message else { return }
            guard let oldValue = oldValue else { return }
            if oldValue != message{
                self.titleLabel.mildShake()
            }
            switch message {
            case .Greetings(let message):
                self.titleLabel.text = "\(message)"
                break
            case .TotalMessage(let prefix, let total):
                self.titleLabel.text = total == 0 ? "" : "\(prefix) \(total)"
                break
            }
        }
    }
}
