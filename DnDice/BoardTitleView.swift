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
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: SpringLabel!
    
    private var timer = Timer()
    
    override func initialize() {
        super.initialize()
        xibSetup(nibName: "BoardTitleView")
        self.resetTimer()
    }
    
    private func resetTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFired(timer:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    internal func timerFired(timer: Timer){
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
                self.titleLabel.text = "\(prefix) \(total)"
                break
            }
        }
    }
    
    var total: Int = 0 {
        didSet{
            resetTimer()
        }
    }
    
    var greetings = [""]
}

extension Array{
    func getRandom() -> Element{
        return self[randomise(min: 0, max: self.count - 1)]
    }
}

enum DiceMessage: Equatable{
    case TotalMessage(prefix: String, total: Int)
    case Greetings(message: String)
}

func ==(lhs: DiceMessage, rhs: DiceMessage) -> Bool{
    switch (lhs, rhs){
    case ( .Greetings, .Greetings):
        return true
    case ( .TotalMessage, .TotalMessage):
        return true
    default:
        return false
    }
}
