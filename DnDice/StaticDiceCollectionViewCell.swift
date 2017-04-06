//
//  StaticDiceCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 03/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring

class StaticDiceCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var valueLabel: SpringLabel!
    @IBOutlet weak var imageView: SpringImageView!
    
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
        self.imageView.wobble { 
            completion?()
        }
    }
}
