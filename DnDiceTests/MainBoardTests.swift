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
    
    var disposeBag: DisposeBag!
    var boardViewController: BoardViewController!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //let's test if it really is adding dices
    func testRolledDicesExist(){
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let rootNav = storyboard.instantiateInitialViewController() as! UINavigationController
        let gameViewController = rootNav.topViewController as! GameViewController
        let boardViewController = gameViewController.boardViewController
        
        UIApplication.shared.keyWindow!.rootViewController = rootNav
        
        //weird thing you have to do to
        //to force apple to prepare your views
        XCTAssertNotNil(rootNav.view)
        XCTAssertNotNil(gameViewController.view)
        XCTAssertNotNil(boardViewController.view)
        
        
    }
}
