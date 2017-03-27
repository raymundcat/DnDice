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
    
    func testDiceSides(){
        let dice4 = Dice(sides: .Four)
        self.test(dice: dice4, withSide: 4)
        
        let dice5 = Dice(sides: .Five)
        self.test(dice: dice5, withSide: 5)
        
        let dice6 = Dice(sides: .Six)
        self.test(dice: dice6, withSide: 6)
        
        let dice10 = Dice(sides: .Ten)
        self.test(dice: dice10, withSide: 9)
        
        let dice20 = Dice(sides: .Twenty)
        self.test(dice: dice20, withSide: 20)
    }
    
    func test(dice: Dice, withSide sideMax: Int){
        for _ in 0..<100 {
            let diceExpectation = expectation(description: "fulfilled")
            dice.roll(onComplete: { (newValue) in
                XCTAssert(newValue <= sideMax)
                diceExpectation.fulfill()
            })
        }
        self.waitForExpectations(timeout: 10) { (error) in
            if error != nil{
                print("failed to wait for expectations \(error)")
            }else{
                print("expectations done")
            }
        }
    }
}
