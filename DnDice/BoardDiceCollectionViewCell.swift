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
    
    @IBOutlet weak var valueLabel: BorderedSpringLabel!
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
                doubleShake()
                break
            case .Stable:
                guard let dice = self.dice else{ return }
                self.valueLabel.text = "\(dice.value)"
                break
            }
        }
    }
    
    func mildShake(){
        self.imageView.animation = "pop"
        self.imageView.duration = 0.5
        self.imageView.animate()
    }
    
    func doubleShake(){
        shake {
            self.shake(completion: nil)
        }
    }
    
    func shake(completion: (() -> ())?){
        self.imageView.animation = "swing"
        self.imageView.duration = 0.5
        self.imageView.animate()
        self.imageView.animation = "wobble"
        self.imageView.duration = 0.5
        self.imageView.animateToNext {
            completion?()
        }
    }
    
    func fall(){
        self.valueLabel.text = ""
        self.imageView.animation = "fall"
        self.imageView.curve = "easeOut"
        self.imageView.duration = 3
        self.imageView.animateNext {
            self.shake(completion: nil)
        }
    }
}
