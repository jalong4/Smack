//
//  Message.swift
//  Smack
//
//  Created by Jim Long on 3/20/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation

struct Message {
    public private(set) var id: String
    public private(set) var messageBody: String
    public private(set) var userId: String
    public private(set) var channelId: String
    public private(set) var userName: String
    public private(set) var userAvatar: String
    public private(set) var userAvatarColor: String
    public private(set) var date: Date
    
    init(json: [String: Any]) {
        self.id = json["_id"] as? String ?? ""
        self.messageBody = json["messageBody"] as? String ?? ""
        self.userId = json["userId"] as? String ?? ""
        self.channelId = json["channelId"] as? String ?? ""
        self.userName = json["userName"] as? String ?? ""
        self.userAvatar = json["userAvatar"] as? String ?? ""
        self.userAvatarColor = json["userAvatarColor"] as? String ?? ""
        date = Utils.convertDateFormatter(timestamp: json["timeStamp"] as? String ?? "") ?? Date(timeIntervalSince1970: 0)
    }
}
