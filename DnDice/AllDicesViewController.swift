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
            collectionView.contentInset = UIEdgeInsetsMake(20, sideInsets, 20, sideInsets)
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
        cell.heroModifiers = [.scale(0.5)]
        return cell
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dices.count
    }
    
    let sideInsets: CGFloat = 20
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 3) - (sideInsets)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells{
            if let cell = cell as? StaticDiceCollectionViewCell{
                
            }
        }
        self.didSelect(dice: self.dices[indexPath.row])
    }
    
    func didSelect(dice: Dice){
        guard let delegate = self.delegate else { return }
        delegate.allDicesDidSelect(dice: Dice(sides: dice.sides))
    }
}

let animationRotateDegres: CGFloat = 0.5
let animationTranslateX: CGFloat = 1.0
let animationTranslateY: CGFloat = 1.0
let count: Int = 1

func degreesToRadians(x: CGFloat) -> CGFloat {
    return CGFloat(M_PI) * x / 180.0
}

public extension UIView {
    
    func wobble() {
        let leftOrRight: CGFloat = (count % 2 == 0 ? 1 : -1)
        let rightOrLeft: CGFloat = (count % 2 == 0 ? -1 : 1)
        let leftWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(x: animationRotateDegres * leftOrRight))
        let rightWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(x: animationRotateDegres * rightOrLeft))
        let moveTransform: CGAffineTransform = leftWobble.translatedBy(x: -animationTranslateX, y: -animationTranslateY)
        let conCatTransform: CGAffineTransform = leftWobble.concatenating(moveTransform)
        
        let shrinkTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        transform = rightWobble // starting point
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .autoreverse], animations: { () -> Void in
            self.transform = conCatTransform
        }, completion: nil)
        
        
    }
}
