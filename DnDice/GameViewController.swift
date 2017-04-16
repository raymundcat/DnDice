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

class GameViewController: BaseViewController{
    
    @IBOutlet weak var boardViewContrainer: UIView!
    
    @IBOutlet weak var allDicesViewContainer: UIView!{
        didSet{
            allDicesViewContainer.layer.shadowColor = UIColor.black.cgColor
            allDicesViewContainer.layer.shadowOpacity = 0.3
            allDicesViewContainer.layer.shadowOffset = CGSize.zero
            allDicesViewContainer.layer.shadowRadius = 10
        }
    }
    
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
    
    var titleView: BoardTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(boardViewController)
        boardViewContrainer.addSubview(boardViewController.view)
        boardViewController.view.frame = boardViewContrainer.bounds
        
        addChildViewController(allDicesViewController)
        allDicesViewContainer.addSubview(allDicesViewController.view)
        allDicesViewController.view.frame = allDicesViewContainer.bounds
        allDicesViewController.delegate = self
        
        titleView = BoardTitleView(frame: (self.navigationController?.navigationBar.bounds)!)
        navigationItem.titleView = self.titleView
        
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(DiceImages.getImage(forDiceSide: .Twenty).withRenderingMode(.alwaysTemplate), for: .normal)
        infoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.tintColor = UIColor.white
        infoButton.adjustsImageWhenHighlighted = false
        infoButton.addTarget(self, action: #selector(didPressInfoButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        let dummyButton = UIButton(type: .custom)
        dummyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dummyButton)
    }
    
    internal func didPressInfoButton(){
        self.performSegue(withIdentifier: "SegueToInfo", sender: self)
    }
    
    func throwInBoard(newDice: Dice){
        guard !boardViewController.boardIsBusyDeleting else { return }
        boardViewController.add(dice: newDice)
        newDice.roll(onComplete: { _ in
            self.titleView.total = self.boardViewController.dices.totalValues()
            self.titleView.greetings = DiceTitleBuilder.createMessages(fromDices: self.boardViewController.dices)
        })
    }
}

//MARK: - All Dices Delegate

extension GameViewController: AllDicesViewDelegate{
    func allDicesDidSelect(dice: Dice) {
        throwInBoard(newDice: dice)
    }
}
