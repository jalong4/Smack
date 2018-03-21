//
//  MessageCell.swift
//  Smack
//
//  Created by Jim Long on 3/20/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var messageHeaderLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(message: Message) {


        
        let header = NSMutableAttributedString(string: "\(message.userName) ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black])
        
        let timeAgo = Utils.timeAgoSinceDate(message.date, currentDate: Date(), numericDates: true)
        header.append(NSAttributedString(string: timeAgo, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black]))

        messageHeaderLbl.attributedText = header
        messageBodyLbl.text = message.messageBody
        
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = Utils.getColor(rgba: message.userAvatarColor)
    }

}
