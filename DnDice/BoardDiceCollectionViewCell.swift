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
            valueLabel.outlineColor = UIColor.white
            valueLabel.outlineWidth = 2
            valueLabel.textColor = UIColor.flatMagenta
        }
    }
    
    @IBOutlet weak var imageView: SpringImageView!{
        didSet{
            imageView.layer.shadowColor = UIColor.flatMagenta.cgColor
            imageView.layer.shadowOpacity = 0.75
            imageView.layer.shadowOffset = CGSize.zero
            imageView.layer.shadowRadius = 5
        }
    }
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            diceSide = dice.sides
            dice.state.asObservable().subscribe { [weak self](event) in
                guard let `self` = self else { return }
                guard let state = event.element else { return }
                self.diceState = state
            }.disposed(by: self.rx.disposeBag)
        }
    }
    
    var diceSide: DiceSide?{
        didSet{
            guard let diceSide = diceSide else { return }
            imageView.image = DiceImages.getImage(forDiceSide: diceSide).withRenderingMode(.alwaysTemplate)
        }
    }
    
    var diceState: DiceState = .Stable{
        didSet{
            guard let dice = self.dice else{ return }
            valueLabel.text = "\(dice.value)"
            valueLabel.textColor = dice.value == dice.sides.rawValue ? UIColor.flatOrange : UIColor.flatMagenta
            switch diceState {
            case .Rolling:
                if oldValue != .Rolling{
                    self.playRollSound()
                    self.shake()
                }
                break
            case .Stable:
                if oldValue != .Stable{
                    self.imageView.pop()
                    self.valueLabel.pop()
                    self.playFinishedSound()
                }
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
    
    func fall(completion: (() -> ())?){
        self.playPop()
        self.valueLabel.text = ""
        self.imageView.fall {
            self.imageView.image = UIImage()
            completion?()
        }
    }
}

// MARK: Soundables

extension BoardDiceCollectionViewCell: BoardSoundable, StaticSoundable{
    
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
    
    func playPop() {
        play(url: DiceSoundPaths.getPath(forSound: .Pop))
    }
}
