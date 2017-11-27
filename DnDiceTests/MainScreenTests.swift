//
//  MainScreenTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 13/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import UIKit

@testable import DnDice

class MainScreenTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var gameViewController: GameViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let rootNav = storyboard.instantiateInitialViewController() as! UINavigationController
        gameViewController = rootNav.topViewController as! GameViewController
        
        UIApplication.shared.keyWindow!.rootViewController = rootNav
        
        //weird thing you have to do to
        //to force apple to prepare your views
        XCTAssertNotNil(rootNav.view)
        XCTAssertNotNil(gameViewController.view)
    }
    
    //let's test if the screen is
    //actually showing the total results
    //of rolls
    func testGameScreenShowingProperTotal(){
        var shownTexts = [String]()
        
        let resultExpectation = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        
            let label: UILabel = self.gameViewController.titleView.titleLabel!
            
            label.rx.observe(String.self, "text").subscribe { (event) in
                guard let element = event.element else { return }
                guard let text = element else { return }
                shownTexts.append(text)
            }.disposed(by: self.disposeBag)
            
            for _ in 0...20{
                self.gameViewController.throwInBoard(newDice: Dice.getRandomDice())
            }
            
            //some animations are supposed to happen so let's wait
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                resultExpectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 60) { (error) in
            guard error == nil else { return }
            let result = shownTexts.contains(where: { (text) -> Bool in
                return text.contains("\(self.gameViewController.boardViewController.dices.totalValues())")
            })
            XCTAssertTrue(result)
        }
    }
}
