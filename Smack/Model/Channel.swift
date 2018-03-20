//
//  Channel.swift
//  Smack
//
//  Created by Jim Long on 3/19/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation

struct Channel {
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var description: String

    init(json: [String: Any]) {
        self.id = json["_id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.description = json["description"] as? String ?? ""
    }
}
