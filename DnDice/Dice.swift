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
    
    let id: Int
    let sides: DiceSide!
    
    init(id: Int, sides: DiceSide) {
        self.id = id
        self.sides = sides
    }
    
    var value: Int = 1
    private (set) var state: Variable<DiceState> = Variable(.Stable)
    
    func roll(onComplete: ((_ newValue: Int) -> Void)?){
        self.state.value = .Rolling
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let `self` = self else { return }
            self.value = randomise(min: 1, max: self.sides.rawValue)
            self.state.value = .Stable
            onComplete?(self.value)
        }
    }
    
    public static func ==(lhs: Dice, rhs: Dice) -> Bool{
        return lhs.id == rhs.id
    }
}

class AvailableDices{
    let dices: [Dice]
    init() {
        var dummyDices  = [Dice]()
        for side in iterateEnum(DiceSide.self){
            dummyDices.append(Dice(id: Int(arc4random()), sides: side))
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
