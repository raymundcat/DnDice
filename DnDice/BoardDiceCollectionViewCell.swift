//
//  BoardCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 26/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring

class BoardDiceCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var valueLabel: BorderedSpringLabel!{
        didSet{
            valueLabel.outlineColor = .flatMaroon
        }
    }
    @IBOutlet weak var imageView: SpringImageView!
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            
            valueLabel.text = "\(dice.value)"
            dice.state.asObservable().subscribe { [weak self](event) in
                guard let `self` = self else { return }
                guard let state = event.element else { return }
                self.diceState = state
                
                var diceImage: UIImage!
                switch dice.sides {
                case .Four:
                    diceImage = #imageLiteral(resourceName: "d4")
                    break
                case .Six:
                    diceImage = #imageLiteral(resourceName: "d6")
                    break
                case .Eight:
                    diceImage = #imageLiteral(resourceName: "d8")
                    break
                case .Ten:
                    diceImage = #imageLiteral(resourceName: "d10")
                    break
                case .Twelve:
                    diceImage = #imageLiteral(resourceName: "d12")
                    break
                case .Twenty:
                    diceImage = #imageLiteral(resourceName: "d20")
                    break
                }
                self.imageView.image = diceImage.withRenderingMode(.alwaysTemplate)
            }.addDisposableTo(self.rx_disposeBag)
        }
    }
    
    var diceState: DiceState = .Stable{
        didSet{
            switch diceState {
            case .Rolling:
                self.valueLabel.text = ""
                self.shake()
                self.randomiseValueLabel()
                break
            case .Stable:
                guard let dice = self.dice else{ return }
                self.valueLabel.text = "\(dice.value)"
                self.valueLabel.mildShake()
                break
            }
        }
    }
    
    func randomiseValueLabel(){
        for i in 0...9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1, execute: {
                self.valueLabel.text = "\(randomise(min: 1, max: self.dice?.sides.rawValue ?? 1))"
            })
        }
    }
    
    func pulse(){
        self.imageView.mildShake()
        if self.dice?.value == self.dice?.sides.rawValue{
            self.imageView.excitedPop()
            self.valueLabel.pop()
        }
    }
    
    func shake(){
        self.imageView.extraShake()
        self.valueLabel.extraShake()
    }
    
    func fall(){
        self.valueLabel.text = ""
        self.imageView.fall { 
            self.imageView.image = UIImage()
        }
    }
}

extension Springable{
    
    func excitedPop(){
        self.animation = "pop"
        self.duration = 2
        self.force = 2
        self.curve = "easeOut"
        self.rotate = 3
        self.animate()
    }
    
    func pop(){
        self.animation = "pop"
        self.duration = 1.5
        self.force = 2
        self.curve = "easeOut"
        self.animate()
    }
    
    func fall(completion: (() -> ())?){
        self.animation = "fall"
        self.curve = "easeOut"
        self.duration = 1.5
        self.animateToNext {
            self.mildShake()
            completion?()
        }
    }
    
    func mildShake(){
        self.animation = "pop"
        self.duration = 1.5
        self.force = 0.5
        self.animate()
    }
    
    func shake(completion: (() -> ())?){
        self.animation = "swing"
        self.duration = 0.5
        self.animate()
        self.animation = "wobble"
        self.duration = 0.5
        self.animateToNext {
            completion?()
        }
    }
    
    func extraShake(){
        self.shake { 
            self.shake(completion: nil)
        }
    }
    
    func wobble(completion: (() -> ())?) {
        self.animation = "pop"
        self.curve = "easeIn"
        self.duration = 0.5
        self.animate()
        self.animation = "swing"
        self.curve = "easeIn"
        self.duration = 0.5
        self.animateToNext {
            completion?()
        }
    }
}
