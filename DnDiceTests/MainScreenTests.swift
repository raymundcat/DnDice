//
//  MainScreenTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 13/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
//import Rxte
@testable import DnDice

class MainScreenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRootNavExists(){
        XCTAssertNotNil(getRootNavController)
    }
    
    func getRootNavController() -> UINavigationController? {
        //create view controller
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: RootNavigationControllerID)  as? UINavigationController
    }
    
    func testGetMainScreenExists(){
        XCTAssertNotNil(getGameViewController(fromRootNav:getRootNavController()!))
    }
    
    func getGameViewController(fromRootNav rootNav: UINavigationController) -> GameViewController? {
        return getRootNavController()?.viewControllers[0] as? GameViewController
    }
    
    func testGameScreenShowingProperTotal(){
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let rootNav = storyboard.instantiateInitialViewController() as! UINavigationController
        let gameScreen = rootNav.topViewController as! GameViewController
        
        UIApplication.shared.keyWindow!.rootViewController = gameScreen
        
        // The One Weird Trick!
        let _ = rootNav.view
        let _ = gameScreen.view
        
        var shownTexts = [String]()
        
        let resultExpectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            gameScreen.titleView.titleLabel.rx.observe(String.self, "text").subscribe { (event) in
//                guard let element = event.element else { return }
//                guard let text = element else { return }
//                shownTexts.append(text)
//                }.addDisposableTo(self.rx_disposeBag)
//            gameScreen.allDicesDidSelect(dice: Dice(sides: .Four))
//            gameScreen.titleView.titleLabel.text
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let result = shownTexts.contains(where: { (text) -> Bool in
                    return text.contains("\(gameScreen.boardViewController.dices.totalValues())")
                })
                
                XCTAssertTrue(result)
                resultExpectation.fulfill()
            }
        }
        
        self.wait(for: [resultExpectation], timeout: 10)
    }
}
