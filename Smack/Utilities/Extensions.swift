//
//  Extensions.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
