//
//  ChannelCell.swift
//  Smack
//
//  Created by Jim Long on 3/19/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layer.backgroundColor = selected ? UIColor(white: 1, alpha: 0.2).cgColor : UIColor.clear.cgColor
    }
    
    func configureCell(channel: Channel) {
        channelLbl.text = "#\(channel.name)"
        channelLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        if MessageService.instance.unreadChannels.contains(channel.id) {
            channelLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        }
        
    }

}
