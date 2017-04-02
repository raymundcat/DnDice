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
    
    var dicesInBoard: [Dice] = [Dice]()
    
    @IBOutlet weak var boardViewContrainer: UIView!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var allDicesViewContainer: UIView!{
        didSet{
           
        }
    }
    
    var availableDices: AvailableDices = {
       return AvailableDices()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "AllDicesViewController") as! AllDicesViewController
        self.addChildViewController(viewController)
        allDicesViewContainer.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: GameViewController.self())
    }
}
