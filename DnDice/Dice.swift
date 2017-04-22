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
    
    let sides: DiceSide
    
    init(sides: DiceSide) {
        self.sides = sides
    }
    
    private (set) var value: Int = 1
    private (set) var state: Variable<DiceState> = Variable(.Stable)
    
    func roll(onComplete: ((_ newValue: Int) -> Void)?){
        for i in 0...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1, execute: { [weak self] in
                guard let `self` = self else { return }
                self.value = randomise(min: 1, max: self.sides.rawValue)
                
                if i != 10{
                    self.state.value = .Rolling
                }else{
                    self.state.value = .Stable
                    onComplete?(self.value)
                }
            })
        }
    }
    
    func isValueTheSame(withDice dice: Dice) -> Bool{
        return self.sides == dice.sides && self.value == dice.value
    }
    
    static func getRandomDice() -> Dice{
        var dummyDices  = [Dice]()
        for side in iterateEnum(DiceSide.self){
            dummyDices.append(Dice(sides: side))
        }
        return dummyDices.getRandom()
    }
    
    static func generateRandomSet(ofMaxCount count: Int) -> [Dice] {
        let finalCount = randomise(min: 1, max: count)
        var dices = [Dice]()
        for _ in 1...finalCount{
            dices.append(Dice.getRandomDice())
        }
        return dices
    }
}

class AvailableDices{
    private (set) var dices = [Dice]()
    init() {
        for side in iterateEnum(DiceSide.self){
            dices.append(Dice(sides: side))
        }
    }
}

enum DiceSide: Int{
    case Four = 4
    case Six = 6
    case Eight = 8
    case Ten = 10
    case Twelve = 12
    case Twenty = 20
}

enum DiceState{
    case Rolling
    case Stable
}

extension Array where Element: Dice{
    func totalValues() -> Int {
        return self.reduce(0, { (result, dice) -> Int in
            if dice.state.value == .Stable{
                return result + dice.value
            }else{
                return result
            }
        })
    }
}
