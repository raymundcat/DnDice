//
//  BioardViewController.swift
//  DnDice
//
//  Created by John Raymund Catahay on 01/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

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
            refreshControl.tintColor = .white
            collectionView.addSubview(refreshControl)
            collectionView.alwaysBounceVertical = true
            collectionView.heroModifiers = [.cascade]
            collectionView.contentInset = UIEdgeInsetsMake(20, sideInsets, 20, sideInsets)
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
            }) { (completed) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let lastIndexPath = newIndexpaths.last{
                        self.collectionView.scrollToItem(at: lastIndexPath, at: .centeredVertically, animated: true)
                    }
                }
            }
        }
    }
    
    func removeDices(){
        for cell in self.collectionView.visibleCells{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(randomise(min: 1, max: 10)) * 0.05, execute: {
                if let cell = cell as? BoardDiceCollectionViewCell{
                    cell.fall()
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.collectionView.performBatchUpdates({ 
                for (index, _) in self.dices.enumerated(){
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
                self.dices.removeAll()
            }, completion: { (completed) in
                self.refreshControl.endRefreshing()
            })
            
        }
    }
    
    var randomShakeTimer = Timer()
    
    func randomlyShakeDices(){
        for cell in self.collectionView.visibleCells{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(randomise(min: 1, max: 10)) * 0.1, execute: {
                if let cell = cell as? BoardDiceCollectionViewCell, randomise(min: 1, max: 5) == 1{
                    cell.pulse()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomShakeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (imer) in
            self.randomlyShakeDices()
        })
        randomShakeTimer.fire()
        self.collectionView.backgroundColor = .clear
        self.collectionView.backgroundView?.backgroundColor = .clear
        self.view.backgroundColor = UIColor.init(gradientStyle: .topToBottom, withFrame: self.collectionView.bounds, andColors: [UIColor.flatMaroon.lighten(byPercentage: 0.2)!, .flatMaroonDark])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        randomShakeTimer.invalidate()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BoardDiceCollectionViewCell
        cell.dice = dices[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BoardDiceCollectionViewCell else { return }
        cell.pulse()
    }
    
    let sideInsets: CGFloat = 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.size.width - (sideInsets * 2)) / 3) - 8
        return CGSize(width: width, height: width)
    }
}
