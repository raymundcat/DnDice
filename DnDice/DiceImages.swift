//
//  DiceImages.swift
//  DnDice
//
//  Created by John Raymund Catahay on 07/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import UIKit

class DiceImages{
    static func getImage(forDiceSide diceSide: DiceSide) -> UIImage{
        switch diceSide {
        case .Four:
            return #imageLiteral(resourceName: "d4")
        case .Six:
            return #imageLiteral(resourceName: "d6")
        case .Eight:
            return #imageLiteral(resourceName: "d8")
        case .Ten:
            return #imageLiteral(resourceName: "d10")
        case .Twelve:
            return #imageLiteral(resourceName: "d12")
        case .Twenty:
            return #imageLiteral(resourceName: "d20")
        }
    }
}
