//
//  AllDicesBoardTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 15/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
import RxSwift
@testable import DnDice

class AllDicesBoardTests: XCTestCase {
    
    var allDicesViewController: AllDicesViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let rootNav = storyboard.instantiateInitialViewController() as! UINavigationController
        let gameViewController = rootNav.topViewController as! GameViewController
        allDicesViewController = gameViewController.allDicesViewController
        
        UIApplication.shared.keyWindow!.rootViewController = rootNav
        
        //weird thing you have to do to
        //to force apple to prepare your views
        XCTAssertNotNil(rootNav.view)
        XCTAssertNotNil(gameViewController.view)
        XCTAssertNotNil(allDicesViewController.view)
    }
    
    //test if all the dices in the enum exists
    func testAllDicesExists(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            let allDices = AvailableDices()
            for dice in allDices.dices{
                XCTAssertTrue(self.allDicesViewController.dices.contains(where: { (mDice) -> Bool in
                    return dice.sides == mDice.sides
                }))
            }
        }
    }
}
