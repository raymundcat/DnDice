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
            self.imageView.image = DiceImages.getImage(forDiceSide: diceSide).withRenderingMode(.alwaysTemplate)
        }
    }
    
    var diceState: DiceState = .Stable{
        didSet{
            guard let dice = self.dice else{ return }
            self.valueLabel.text = "\(dice.value)"
            
            switch diceState {
            case .Rolling:
                if oldValue != .Rolling{
                    self.playRollSound()
                    self.shake()
                }
                break
            case .Stable:
                self.imageView.pop()
                self.valueLabel.pop()
                self.pause()
                break
            }
        }
    }
    
    internal var player: AVAudioPlayer?
    
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

extension BoardDiceCollectionViewCell: BoardSoundable{
    
    func play(url: URL) {
        pause()
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func playRollSound() {
        play(url: DiceSoundPaths.getPath(forSound: .Rolling))
    }
    
    func playFinishedSound() {
        play(url: DiceSoundPaths.getPath(forSound: .Finished))
    }
}
