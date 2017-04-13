//
//  BioardViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 01/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import UIKit
import Spring

protocol AllDicesViewDelegate {
    func allDicesDidSelect(dice: Dice)
}

class AllDicesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellID = "staticCellD"
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "StaticDiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.heroModifiers = [.cascade]
            collectionView.contentInset = UIEdgeInsetsMake(sideInsets, sideInsets * 2, sideInsets, sideInsets * 2)
        }
    }
    
    var dices: [Dice]!
    var delegate: AllDicesViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dices = AvailableDices().dices
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StaticDiceCollectionViewCell
        cell.dice = dices[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
    
    let sideInsets: CGFloat = 20
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.height / 2) - (sideInsets)
        return CGSize(width: width, height: width)
    }
    
    func didSelect(dice: Dice){
        guard let delegate = self.delegate else { return }
        delegate.allDicesDidSelect(dice: Dice(sides: dice.sides))
    }
}

extension AllDicesViewController: StaticDiceCellDelegate{
    func staticDiceDidSelect(withDice dice: Dice) {
        self.didSelect(dice: dice)
    }
}
