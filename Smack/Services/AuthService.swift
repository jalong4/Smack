//
//  AuthService.swift
//  Smack
//
//  Created by Jim Long on 3/18/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.error == nil {
                
                guard
                    let json = response.result.value as? [String: Any],
                    let email = json["user"] as? String,
                    let token = json["token"] as? String
                else {
                    completion(false)
                    return
                }

                self.userEmail = email
                self.authToken = token
                self.isLoggedIn = true

                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": AUTHORIZATION_KEY
        ]
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.error == nil {
                guard
                    let json = response.result.value as? [String: Any],
                    let id = json["_id"] as? String,
                    let color = json["avatarColor"] as? String,
                    let avatarName = json["avatarName"] as? String,
                    let email = json["email"] as? String,
                    let name = json["name"] as? String
                    else {
                        completion(false)
                        return
                }
                UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
    
    func findUser(email: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let headers = [
            "Authorization": AUTHORIZATION_KEY
        ]
        
        Alamofire.request(URL_FILE_USER_BY_EMAIL + lowerCaseEmail, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: headers).responseJSON(completionHandler: { (response) in
            if response.result.error == nil {
                guard
                    let json = response.result.value as? [String: Any],
                    let id = json["_id"] as? String,
                    let color = json["avatarColor"] as? String,
                    let avatarName = json["avatarName"] as? String,
                    let email = json["email"] as? String,
                    let name = json["name"] as? String
                    else {
                        completion(false)
                        return
                }
                UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
}
