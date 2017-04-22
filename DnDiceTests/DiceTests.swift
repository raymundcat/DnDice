//
//  DiceTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 27/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
@testable import DnDice

class DiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //run test on all sides
    func testDiceSides(){
        let dice4 = Dice(sides: .Four)
        self.test(dice: dice4, withSide: 4)
        
        let dice6 = Dice(sides: .Six)
        self.test(dice: dice6, withSide: 6)
        
        let dice8 = Dice(sides: .Eight)
        self.test(dice: dice8, withSide: 8)
        
        let dice10 = Dice(sides: .Ten)
        self.test(dice: dice10, withSide: 10)
        
        let dice12 = Dice(sides: .Twelve)
        self.test(dice: dice12, withSide: 12)
        
        let dice20 = Dice(sides: .Twenty)
        self.test(dice: dice20, withSide: 20)
    }
    
    //test max results of dices depending on side
    func test(dice: Dice, withSide sideMax: Int){
        for _ in 0..<sideMax*10 {
            let diceExpectation = expectation(description: "fulfilled")
            dice.roll(onComplete: { (newValue) in
                XCTAssert(newValue <= sideMax)
                diceExpectation.fulfill()
            })
        }
        self.waitForExpectations(timeout: 10) { (error) in
            if error != nil{
                print("failed to wait for expectations \(String(describing: error))")
            }else{
                print("expectations done")
            }
        }
    }
    
    //test AvailableDices if it
    //really contains all available dices
    func testAllDices(){
        var allDices = AvailableDices().dices
        
        //all dices must have one dice per dice side
        for side in iterateEnum(DiceSide.self){
            if let diceMatchedIndex = allDices.index(where: { (dice) -> Bool in
                return dice.sides == side
            }){
                allDices.remove(at: diceMatchedIndex)
            }
        }
        
        XCTAssertEqual(0, allDices.count)
    }
    
    //test randomness of a dice
    func testDiceRandomness(){
        
        //make sure dices added aren't all the same
        //make a guard to make sure the next dice becomes different
        var prevDice: Dice?
        var hasProducedDifferent: Bool = false
        for _ in 0...20{
            let newDice = Dice.getRandomDice()
            if let prevDice = prevDice{
                hasProducedDifferent = !prevDice.isValueTheSame(withDice: newDice)
                if hasProducedDifferent {
                    break
                }
            }
            prevDice = newDice
        }
        XCTAssertTrue(hasProducedDifferent)
    }
}
