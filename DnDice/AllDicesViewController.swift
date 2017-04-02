//
//  BioardViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 01/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import UIKit

protocol AllDicesViewDelegate {
    func allDicesDidSelect(dice: Dice)
}

class AllDicesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellID = "cellD"
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "DiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
            
            collectionView.delegate = self
            collectionView.dataSource = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DiceCollectionViewCell
        cell.dice = dices[indexPath.row]
        return cell
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 3) - 11
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelect(dice: self.dices[indexPath.row])
    }
    
    func didSelect(dice: Dice){
        guard let delegate = self.delegate else { return }
        delegate.allDicesDidSelect(dice: dice)
    }
}
