//
//  GlobalFunctions.swift
//  DnDice
//
//  Created by John Raymund Catahay on 16/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation

//returns a random element of an Array
extension Array{
    func getRandom() -> Element{
        return self[randomise(min: 0, max: self.count - 1)]
    }
}

//returns a random Int in between the min and max values
func randomise(min: Int, max: Int) -> Int{
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

//enables iterations through an enum
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
