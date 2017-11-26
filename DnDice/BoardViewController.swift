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

class BoardViewController: BaseViewController{
    
    @IBOutlet weak private var liveBackground: LiveBackgroundView!
    
    private let refreshControl = UIRefreshControl()
    
    fileprivate let sideInsets: CGFloat = 10
    fileprivate let cellID = "boardCellID"
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.backgroundColor = .clear
            collectionView.backgroundView?.backgroundColor = .clear
            
            collectionView.register(UINib(nibName: "BoardDiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
            collectionView.delegate = self
            collectionView.dataSource = self
            
            refreshControl.addTarget(self, action: #selector(removeDices), for: .valueChanged)
            refreshControl.tintColor = .white
            collectionView.addSubview(refreshControl)
            collectionView.alwaysBounceVertical = true
            collectionView.contentInset = UIEdgeInsetsMake(20, sideInsets, 20, sideInsets)
        }
    }
    
    private (set) var boardIsBusyAdding: Bool = false
    
    private (set) var dices: [Dice] = [Dice](){
        didSet{
            boardIsBusyAdding = true
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
                        self.liveBackground.restartAnimations()
                        self.boardIsBusyAdding = false
                    }
                }
            }
        }
    }
    
    func add(dice: Dice){
        self.dices.append(dice)
    }
    
    private (set) var boardIsBusyDeleting: Bool = false
    @objc func removeDices(){
        
        if dices.count == 0 {
            liveBackground.restartAnimations()
            refreshControl.endRefreshing()
            return
        }
        
        guard !boardIsBusyAdding else { return }
        liveBackground.restartAnimations()
        boardIsBusyDeleting = true
        let group = DispatchGroup()
        for (index, cell) in self.collectionView.visibleCells.enumerated(){
            group.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1, execute: {
                if let cell = cell as? BoardDiceCollectionViewCell{
                    cell.fall(completion: { 
                        group.leave()
                    })
                }
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionView.performBatchUpdates({
                    for (index, _) in self.dices.enumerated(){
                        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                    }
                    self.dices.removeAll()
                }, completion: { completed in
                    self.refreshControl.endRefreshing()
                    self.boardIsBusyDeleting = false
                })
            }
        }
    }
    
    private var randomShakeTimer = Timer()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.liveBackground.restartAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        randomShakeTimer.invalidate()
    }
}

// MARK: - CollectionView DataSource

extension BoardViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BoardDiceCollectionViewCell
        cell.dice = dices[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
}

// MARK: - CollectionView Delegate

extension BoardViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BoardDiceCollectionViewCell else { return }
        cell.pulse()
    }
}

// MARK: - CollectionView Delegate Flow Layout

extension BoardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.size.width - (sideInsets * 2)) / 3) - 8
        return CGSize(width: width, height: width)
    }
}
