//
//  MessageService.swift
//  Smack
//
//  Created by Jim Long on 3/19/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation
import Alamofire

class MessageService {
    static let instance = MessageService()
    public private(set) var channels = [Channel]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: AUTH_HEADER).responseData(completionHandler: { (response) in
            
            switch response.result {
            case .success(let data):
                guard
                    let jsonArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                else {
                    completion(false)
                    return
                }
                for json in jsonArray {
                    self.channels.append(Channel(json: json))
                }
                completion(true)
                
                
            case .failure(let error):
                completion(false)
                debugPrint(error)
            }
        })
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "name": name,
            "description": description
        ]
        
        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default , headers: AUTH_HEADER).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let message =  json["message"] as? String {
                    print(message)
                }
                completion(true)
                
                
            case .failure(let error):
                completion(false)
                debugPrint(error)
            }
        })
        
    }
    
    func clearChannels() {
        channels.removeAll()
    }


}
