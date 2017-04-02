//
//  BioardViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 01/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import UIKit

protocol BoardViewDelegate {
    func boardDidSet(newTotal total: Int)
}

class BoardViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let refreshControl = UIRefreshControl()
    private let cellID = "boardCellID"
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.register(UINib(nibName: "BoardDiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
            collectionView.delegate = self
            collectionView.dataSource = self
            
            refreshControl.addTarget(self, action: #selector(removeDices), for: .valueChanged)
            collectionView.addSubview(refreshControl)
            collectionView.alwaysBounceVertical = true
            collectionView.heroModifiers = [.cascade]
        }
    }
    
    var dices: [Dice] = [Dice](){
        didSet{
            var newIndexpaths = [IndexPath]()
            for (index, dice) in self.dices.enumerated(){
                if !oldValue.contains(dice){
                    newIndexpaths.append(IndexPath(row: index, section: 0))
                }
            }
            collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: newIndexpaths)
            })
        }
    }
    
    func removeDices(){
        collectionView.performBatchUpdates({
            for (index, _) in self.dices.enumerated(){
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
            self.dices.removeAll()
        })
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BoardDiceCollectionViewCell
        cell.heroModifiers = [.scale(0.5)]
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
}
