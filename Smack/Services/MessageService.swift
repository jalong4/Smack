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
    
    func clearChannels() {
        channels.removeAll()
    }


}
