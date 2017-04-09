//
//  ViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 25/03/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class GameViewController: BaseViewController, AllDicesViewDelegate{
    
    @IBOutlet weak var boardViewContrainer: UIView!
    
    @IBOutlet weak var allDicesViewContainer: UIView!
    
    lazy var allDicesViewController: AllDicesViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AllDicesViewController") as! AllDicesViewController
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return viewController
    }()
    
    lazy var boardViewController: BoardViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BoardViewController") as! BoardViewController
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return viewController
    }()
    
    var availableDices: AvailableDices = {
       return AvailableDices()
    }()
    
    var titleView: BoardTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(boardViewController)
        self.boardViewContrainer.addSubview(boardViewController.view)
        self.boardViewController.view.frame = boardViewContrainer.bounds
        
        self.addChildViewController(allDicesViewController)
        self.allDicesViewContainer.addSubview(allDicesViewController.view)
        self.allDicesViewController.view.frame = allDicesViewContainer.bounds
        self.allDicesViewController.delegate = self
        
        self.titleView = BoardTitleView(frame: (self.navigationController?.navigationBar.bounds)!)
        self.navigationItem.titleView = self.titleView
    }
    
    //MARK: All Dices Delegate
    func allDicesDidSelect(dice: Dice) {
        boardViewController.dices.append(dice)
        dice.roll(onComplete: { _ in
//            self.titleView.setTitle(title: "Total: \(self.boardViewController.dices.totalValues())")
            self.titleView.total = self.boardViewController.dices.totalValues()
            self.titleView.greetings = DiceTitleBuilder.createMessages(fromDices: self.boardViewController.dices)
        })
    }
}
