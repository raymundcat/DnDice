//
//  BaseViewController.swift
//  TryBooking
//
//  Created by White Widget on 23/01/2017.
//  Copyright © 2017 White Widget. All rights reserved.
//

import Foundation
import UIKit
//import MBProgressHUD
//import ZHPopupView
import RxSwift
import RxCocoa
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func showAlert(title: String, message: String, onComplete: (() -> Void)? = nil){
//        let alertView = ZHPopupView.popupNomralAlertView(in: self.view, backgroundStyle: ZHPopupViewBackgroundType_Blur, title: title, content: message, buttonTitles: ["Okay"], confirmBtnTextColor: UIColor.black, otherBtnTextColor: UIColor.black) { (index) in
//            onComplete?()
//        }
//        DispatchQueue.main.async { 
//            alertView?.present()
//        }
    }
    
    func showProgress() {
        hideProgress()
//        DispatchQueue.main.async {
//            let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
//            progress.mode = .indeterminate
//        }
    }
    
    func showProgress(title: String?, message: String?) {
        hideProgress()
//        DispatchQueue.main.async {
//            let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
//            progress.mode = .indeterminate
//            progress.label.text = title
//            progress.detailsLabel.text = message
//        }
    }
    
    func hideProgress() {
//        DispatchQueue.main.async {
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }
    }
}

extension BaseViewController: BasePresenterDelegate{
    func presenterDelegateShowAlert(title: String, message: String, onComplete: (() -> Void)? = nil) {
        self.showAlert(title: title, message: message, onComplete: {
            onComplete?()
        })
    }
    
    func presenterDelegateShowProgress() {
        self.showProgress()
    }
    
    func presenterDelegateShowProgress(title: String?, message: String?) {
        self.showProgress(title: title, message: message)
    }
    
    func presenterDelegateHideProgress() {
        self.hideProgress()
    }
}
