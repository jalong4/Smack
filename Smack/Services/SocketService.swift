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
            NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            completion(true)
        }

        
    }
    
    func addMessage(messageBody: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit(NEW_MESSAGE, messageBody, user.id, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {
        socket.on(MESSAGE_CREATED) { (dataArray, ack) in
            
            if dataArray.count < 8 {
                completion(false)
                return
            }
            
            let json = [
                "messageBody": dataArray[0],
                "userId": dataArray[1],
                "channelId": dataArray[2],
                "userName": dataArray[3],
                "userAvatar": dataArray[4],
                "userAvatarColor": dataArray[5],
                "_id": dataArray[6],
                "timestamp": dataArray[7]
            ]
            
            guard
                let selectedChannelId = MessageService.instance.selectedChannel?.id,
                let channelId = json["channelId"] as? String
            
            else {
                completion(false)
                return
            }
            
            if channelId == selectedChannelId && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(Message(json: json))
            }
            
            completion(true)
        }
    }
}
