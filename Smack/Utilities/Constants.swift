//
//  Constants.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// Seques

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants

let BASE_URL = "https://smack-chatapp.herokuapp.com"
let URL_REGISTER = "\(BASE_URL)/v1/account/register"
let URL_LOGIN = "\(BASE_URL)/v1/account/login"
let URL_USER_ADD = "\(BASE_URL)/v1/user/add"

// Headers
let AUTHORIZATION_KEY = "Bearer \(AuthService.instance.authToken)"
