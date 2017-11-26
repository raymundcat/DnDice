//
//  BaseViewController.swift
//  TryBooking
//
//  Created by White Widget on 23/01/2017.
//  Copyright © 2017 White Widget. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import NSObject_Rx
import Hero

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initStyle()
    }
    
    func initStyle(){
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
