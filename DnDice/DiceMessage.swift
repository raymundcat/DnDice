//
//  DiceMessage.swift
//  DnDice
//
//  Created by John Raymund Catahay on 17/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation

enum DiceMessage: Equatable{
    case TotalMessage(prefix: String, total: Int)
    case Greetings(message: String)
}

func ==(lhs: DiceMessage, rhs: DiceMessage) -> Bool{
    switch (lhs, rhs){
    case ( .Greetings, .Greetings):
        return true
    case ( .TotalMessage, .TotalMessage):
        return true
    default:
        return false
    }
}
