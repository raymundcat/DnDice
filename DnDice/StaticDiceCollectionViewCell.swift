//
//  StaticDiceCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 03/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit

class StaticDiceCollectionViewCell: BaseCollectionViewCell {

   @IBOutlet weak var valueLabel: UILabel!
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            valueLabel.text = "\(dice.sides.rawValue)"
        }
    }
}
