//
//  BaseViewControllerPresenterDelegate.swift
//  TryBooking
//
//  Created by White Widget on 27/01/2017.
//  Copyright © 2017 White Widget. All rights reserved.
//

import Foundation

protocol BasePresenterDelegate: class {
    func presenterDelegateShowAlert(title: String, message: String, onComplete: (() -> Void)?)
    func presenterDelegateShowProgress()
    func presenterDelegateShowProgress(title: String?, message: String?)
    func presenterDelegateHideProgress()
}
