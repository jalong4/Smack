//
//  CicrleImage.swift
//  Smack
//
//  Created by Jim Long on 3/18/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

@IBDesignable
class CicrleImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }

}
