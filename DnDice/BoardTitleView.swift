//
//  BoardTitleView.swift
//  DnDice
//
//  Created by John Raymund Catahay on 09/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import RxCocoa

class BoardTitleView: BaseView {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func initialize() {
        super.initialize()
        xibSetup(nibName: "BoardTitleView")
        titleLabel.rx.observe(String.self, "text").asObservable().subscribe { (event) in
            guard let text = event.element! else { return }
            self.didChangeText(text: text)
        }.addDisposableTo(rx_disposeBag)
    }
    
    private func didChangeText(text: String){
        print("lmao")
    }
    
    func setTitle(title: String){
        titleLabel.text = title
    }
}
