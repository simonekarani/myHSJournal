//
//  RoundButton.swift
//  myHSJournal
//
//  Created by Simone Karani on 11/7/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blue.cgColor
    }

    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
}
