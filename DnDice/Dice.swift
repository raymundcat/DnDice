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
    
    var value: Int = 1
    private (set) var state: Variable<DiceState> = Variable(.Stable)
    
    func roll(onComplete: ((_ newValue: Int) -> Void)?){
        self.state.value = .Rolling
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let `self` = self else { return }
            self.value = randomise(min: 1, max: self.sides.rawValue)
            self.state.value = .Stable
            onComplete?(self.value)
        }
    }
}

class AvailableDices{
    let dices: [Dice]
    init() {
        var dummyDices  = [Dice]()
        for side in iterateEnum(DiceSide.self){
            dummyDices.append(Dice(sides: side))
        }
        dices = dummyDices
    }
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
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

func randomise(min: Int, max: Int) -> Int{
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
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
