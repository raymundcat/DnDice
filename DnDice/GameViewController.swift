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

class Storyboard{
    static func getViewController<VCClass: UIViewController>(withID id: String, asVCClass vcClass: VCClass.Type, fromStoryBoardName name: String = "Main") -> VCClass? {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as? VCClass
    }
}

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
        return Storyboard.getViewController(withID: "AllDicesViewController", asVCClass: AllDicesViewController.self) ?? AllDicesViewController()
    }()
    
    lazy var boardViewController: BoardViewController = {
        return Storyboard.getViewController(withID: "BoardViewController", asVCClass: BoardViewController.self) ?? BoardViewController()
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
    }
    
    @objc internal func didPressInfoButton(){
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
