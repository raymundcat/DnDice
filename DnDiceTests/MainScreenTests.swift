//
//  MainScreenTests.swift
//  DnDice
//
//  Created by John Raymund Catahay on 13/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import UIKit

@testable import DnDice

class MainScreenTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
            
            let label: UILabel = gameScreen.titleView.titleLabel!
            label.rx.observe(String.self, "text").subscribe { (event) in
                guard let element = event.element else { return }
                guard let text = element else { return }
                shownTexts.append(text)
                }.addDisposableTo(self.disposeBag)
            
            for _ in 0...20{
                gameScreen.throwInBoard(newDice: Dice(sides: .Twenty))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                resultExpectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 60) { (error) in
            guard error == nil else { return }
            let result = shownTexts.contains(where: { (text) -> Bool in
                return text.contains("\(gameScreen.boardViewController.dices.totalValues())")
            })
            XCTAssertTrue(result)
        }
    }
}
