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
    @IBOutlet weak var imageView: UIImageView!
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            valueLabel.text = "\(dice.sides.rawValue)"
            
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
        }
    }
}
