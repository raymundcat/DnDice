//
//  DiceTitleBuilder.swift
//  DnDice
//
//  Created by John Raymund Catahay on 09/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation

class DiceTitleBuilder {
    static func createMessages(fromDices dices: [Dice]) -> [String]{
        
        var messages: [String] = [String]()
        
        var niceRollCount = 0
        var almostRollCount = 0
        var pittyRollCount = 0
        var averageRollCount = 0
        var totalExpected = 0
        var totalGot = 0
        
        for dice in dices{
            if dice.value == dice.sides.rawValue {
                niceRollCount += 1
            }else if dice.value == dice.sides.rawValue - 1 {
                almostRollCount += 1
            }else if dice.value == 1{
                pittyRollCount += 1
            }else{
                averageRollCount += 1
            }
            
            totalExpected += dice.sides.rawValue
            totalGot += dice.value
        }
        
        if pittyRollCount > niceRollCount {
            messages.append("ouch!")
        }
        
        if pittyRollCount > averageRollCount {
            messages.append("hmm, maybe let's try again")
        }
        
        if niceRollCount > pittyRollCount{
            if pittyRollCount == 0{
                messages.append("awesome!")
            }else{
                messages.append("some bad, but awesome roll!")
            }
        }
        
        if pittyRollCount == 0 && niceRollCount == 0 {
            if almostRollCount > 0 {
                messages.append("ooh, almost!")
            }
        }
        
        let ratio: Double = Double(totalGot) / Double(totalExpected)
        if ratio > 0.8{
            messages.append("awesome roll!")
        }else if ratio > 0.5{
            messages.append("good roll!")
        }else if ratio > 0.3{
            messages.append("okay-ish roll i guess")
        }else{
            messages.append("hmm, maybe let's try again")
        }
        
        return messages
    }
}
