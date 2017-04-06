//
//  BoardCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 26/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring
import AVFoundation

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
            self.diceSide = dice.sides
            dice.state.asObservable().subscribe { [weak self](event) in
                guard let `self` = self else { return }
                guard let state = event.element else { return }
                self.diceState = state
            }.addDisposableTo(self.rx_disposeBag)
        }
    }
    
    var diceSide: DiceSide?{
        didSet{
            guard let diceSide = diceSide else { return }
            var diceImage: UIImage!
            switch diceSide {
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
        }
    }
    
    var diceState: DiceState = .Stable{
        didSet{
            guard let dice = self.dice else{ return }
            self.valueLabel.text = "\(dice.value)"
            
            switch diceState {
            case .Rolling:
                if oldValue != .Rolling{
                    self.playSound()
                    self.shake()
                }
                break
            case .Stable:
                self.imageView.pop()
                self.valueLabel.pop()
                break
            }
        }
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        let url = Bundle.main.url(forResource: "roulette", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pulse(){
        self.imageView.mildShake()
        if self.dice?.value == self.dice?.sides.rawValue{
            self.pop()
        }
    }
    
    func pop(){
        self.imageView.excitedPop()
        self.valueLabel.pop()
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
