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

    var outlineWidth: CGFloat = 4
    var outlineColor: UIColor = UIColor.darkGray
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
