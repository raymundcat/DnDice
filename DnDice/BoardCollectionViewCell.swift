//
//  BoardCollectionViewCell.swift
//  DnDice
//
//  Created by John Raymund Catahay on 26/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    var dice: Dice?{
        didSet{
            guard let dice = self.dice else{ return }
            
            valueLabel.text = "\(dice.value)"
            dice.state.asObservable().subscribe { [weak self](event) in
                guard let `self` = self else { return }
                guard let state = event.element else { return }
                
                switch state {
                case .Rolling:
                    self.valueLabel.text = "rolling.."
                    break
                case .Stable:
                    self.valueLabel.text = "\(dice.value)"
                    break
                }
                
            }.addDisposableTo(self.rx_disposeBag)
        }
    }
}
