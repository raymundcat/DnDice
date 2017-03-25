//
//  Dice.swift
//  DnDice
//
//  Created by John Raymund Catahay on 26/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class Dice: NSObject{
    
    let sides: DiceSide!
    
    init(sides: DiceSide) {
        self.sides = sides
    }
    
    var value: Int = 1
    private (set) var state: Variable<DiceState> = Variable(.Stable)
    
    func roll(){
        self.state.value = .Rolling
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let `self` = self else { return }
            self.value = randomise(min: 1, max: self.sides.rawValue)
            self.state.value = .Stable
        }
    }
}

enum DiceSide: Int{
    case Four = 4
    case Five = 5
    case Six = 6
    case Ten = 10
    case Twenty = 20
}

enum DiceState{
    case Rolling
    case Stable
}

func randomise(min: Int, max: Int) -> Int{
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}
