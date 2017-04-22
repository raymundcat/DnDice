//
//  MainBoardTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 14/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
import RxSwift
@testable import DnDice

class MainBoardTests: XCTestCase {
    
    var boardViewController: BoardViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let rootNav = storyboard.instantiateInitialViewController() as! UINavigationController
        let gameViewController = rootNav.topViewController as! GameViewController
        boardViewController = gameViewController.boardViewController
        
        UIApplication.shared.keyWindow!.rootViewController = rootNav
        
        //weird thing you have to do to
        //to force apple to prepare your views
        XCTAssertNotNil(rootNav.view)
        XCTAssertNotNil(gameViewController.view)
        XCTAssertNotNil(boardViewController.view)
        XCTAssertNotNil(boardViewController.collectionView)
    }
    
    //let's test if it really is adding dices
    func testRolledDicesExist(completion: @escaping () -> Void){
        
        var rolledDices = [Dice]()
        let resultExpectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for _ in 0...20{
                let dice = Dice.getRandomDice()
                self.boardViewController.add(dice: dice)
                rolledDices.append(dice)
            }
            
            //some animations are supposed to happen so let's wait
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                resultExpectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            guard error == nil else { return }
            
            for rolledDice in rolledDices{
                XCTAssertTrue(self.boardViewController.dices.contains(rolledDice))
                XCTAssertEqual(rolledDices.count, self.boardViewController.collectionView.numberOfItems(inSection: 0))
            }
            completion()
        }
    }
    
    //test if the delete call actually deletes cells
    func testDicesWereRolledAndDeletedFunction(){
        testRolledDicesExist {
            
            let deleteExpectations = self.expectation(description: "")
            self.boardViewController.removeDices()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                deleteExpectations.fulfill()
            }
            
            self.waitForExpectations(timeout: 13, handler: { (error) in
                guard error != nil else { return }
                XCTAssertLessThanOrEqual(self.boardViewController.collectionView.numberOfItems(inSection: 0), 0)
            })
        }
    }
}
