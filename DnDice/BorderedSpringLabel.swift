//
//  BorderedSpringLabel.swift
//  DnDice
//
//  Created by John Raymund Catahay on 05/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import UIKit
import Spring

class BorderedSpringLabel: SpringLabel {

    var outlineWidth: CGFloat = 6
    var outlineColor: UIColor = UIColor.darkGray
    
    override func drawText(in rect: CGRect) {
        let strokeTextAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue) : outlineColor,
            NSAttributedStringKey.strokeWidth : -1 * outlineWidth,
        ]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
