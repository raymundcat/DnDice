//
//  StaticDiceCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 03/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring
import AVFoundation

protocol StaticDiceCellDelegate {
    func staticDiceDidSelect(withDice dice: Dice)
}

class StaticDiceCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var valueLabel: SpringLabel!{
        didSet{
            valueLabel.textColor = .sunset
        }
    }
    
    @IBOutlet weak var imageView: SpringImageView!{
        didSet{
            imageView.tintColor = .sunset
        }
    }
    
    var delegate: StaticDiceCellDelegate?
    
    override func initialize() {
        super.initialize()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell(geture:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapCell(geture: UITapGestureRecognizer){
        guard let dice = self.dice else { return }
        self.delegate?.staticDiceDidSelect(withDice: dice)
        self.wobble { }
    }
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            self.diceSide = dice.sides
            self.valueLabel.text = "\(dice.sides.rawValue)"
        }
    }
    
    var diceSide: DiceSide?{
        didSet{
            guard let diceSide = diceSide else { return }
            self.imageView.image = DiceImages.getImage(forDiceSide: diceSide).withRenderingMode(.alwaysTemplate)
        }
    }
    
    func wobble(completion: (() -> ())?) {
        self.playPop()
        self.imageView.wobble {
            completion?()
        }
    }
    
    internal var player: AVAudioPlayer?
}

extension StaticDiceCollectionViewCell: StaticSoundable{
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
    
    func playPop() {
        play(url: DiceSoundPaths.getPath(forSound: .Pop))
    }
}
