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

class GameViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    let boardCellID = "boardCell"
    @IBOutlet weak var boardCollectionView: UICollectionView!{
        didSet{
            boardCollectionView.register(UINib(nibName: "BoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: boardCellID)
            boardCollectionView.dataSource = self
            boardCollectionView.delegate = self
        }
    }
    var dicesInBoard: [Dice] = [Dice](){
        didSet{
            boardCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var availableDicesCollectionView: UICollectionView!
    var availableDices: [Dice] = [Dice](){
        didSet{
            availableDicesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dicesInBoard = [Dice(sides: .Six), Dice(sides: .Six)]
    }
    
    //MARK: CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dicesInBoard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: boardCellID, for: indexPath) as! BoardCollectionViewCell
        cell.backgroundColor = UIColor.gray
        cell.dice = dicesInBoard[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dicesInBoard[indexPath.row].roll { _ in }
    }
    
    let cellInset = 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int(collectionView.frame.width / 3) - (cellInset * 2)
        
        return CGSize(width: width, height: width)
    }
}
