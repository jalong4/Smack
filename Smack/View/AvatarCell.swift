//
//  AvatarCell.swift
//  Smack
//
//  Created by Jim Long on 3/18/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

enum AvatarType: Int {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }
    
    func configureCell(index: Int, type: AvatarType) {
        avatarImg.image = UIImage(named: "\(type)\(index)")
        layer.backgroundColor = type == .dark ? UIColor.lightGray.cgColor : UIColor.gray.cgColor
    }
    
    func setupView() {
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
