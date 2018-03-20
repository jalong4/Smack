//
//  SocketService.swift
//  Smack
//
//  Created by Jim Long on 3/20/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: SOCKET_URL)!)
    lazy var socket = manager.defaultSocket
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
        socket.emit(NEW_CHANNEL, name, description)
        completion(true)
        
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on(CHANNEL_CREATED) { (dataArray, ack) in
            
            if dataArray.count < 3 { return }
            
            MessageService.instance.channels.append(Channel(json: ["name": dataArray[0], "description": dataArray[1], "_id": dataArray[2]]))
            completion(true)
        }

        
    }
    
    func addMessage(messageBody: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit(NEW_MESSAGE, messageBody, user.id, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
        
    }
}
