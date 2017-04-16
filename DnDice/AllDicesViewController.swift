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

class AllDicesViewController: BaseViewController{
    
    fileprivate let sideInsets: CGFloat = 20
    fileprivate let cellID = "staticCellD"
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "StaticDiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.heroModifiers = [.cascade]
            collectionView.contentInset = UIEdgeInsetsMake(sideInsets, sideInsets * 2, sideInsets, sideInsets * 2)
        }
    }
    
    var delegate: AllDicesViewDelegate?
    
    private (set) lazy var dices: [Dice]! = {
        return AvailableDices().dices
    }()
    
    func didSelect(dice: Dice){
        guard let delegate = self.delegate else { return }
        delegate.allDicesDidSelect(dice: Dice(sides: dice.sides))
    }
}

// MARK: - CollectionView DataSource

extension AllDicesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! StaticDiceCollectionViewCell
        cell.dice = dices[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
}

// MARK: - CollectionView Delegate Flow Layout

extension AllDicesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.height / 2) - (sideInsets)
        return CGSize(width: width, height: width)
    }
}

// MARK: - Static Dices Delegate

extension AllDicesViewController: StaticDiceCellDelegate{
    func staticDiceDidSelect(withDice dice: Dice) {
        self.didSelect(dice: dice)
    }
}
