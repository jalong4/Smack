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

        messageBodyLbl.text = message.messageBody
        
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = Utils.getColor(rgba: message.userAvatarColor)
        
        let headerBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14)
        let headerRegularFont = UIFont(name: "HelveticaNeue-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12)


        let header = NSMutableAttributedString(string: "\(message.userName) ", attributes: [NSAttributedStringKey.font: headerBoldFont, NSAttributedStringKey.foregroundColor: UIColor.black])
        
        let timestamp = message.date.toString(dateFormat: "MMM d, h:mm a")
        header.append(NSAttributedString(string: timestamp, attributes: [NSAttributedStringKey.font: headerRegularFont, NSAttributedStringKey.foregroundColor: UIColor.darkGray]))

        messageHeaderLbl.attributedText = header
    }

}
