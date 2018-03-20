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
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL Constants

let BASE_URL = "https://smack-chatapp.herokuapp.com"
let SOCKET_URL = "https://smack-chatapp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)/v1/account/register"
let URL_LOGIN = "\(BASE_URL)/v1/account/login"
let URL_USER_ADD = "\(BASE_URL)/v1/user/add"
let URL_FIND_USER_BY_EMAIL = "\(BASE_URL)/v1/user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)/v1/channel"
let URL_ADD_CHANNEL = "\(BASE_URL)/v1/channel/add"

// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

let AUTH_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)"
]

// Reuse Identifiers
let AVATAR_CELL = "AvatarCell"
let CHANNEL_CELL = "ChannelCell"

// Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)

// Notification Constants

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("NotifUserDataChanged")
let NOTIF_CHANNEL_DATA_DID_CHANGE = Notification.Name("NotifChannelDataChanged")
let NOTIF_CHANNEL_SELECTED = Notification.Name("NotifChannelSelected")

// Socket Events
let NEW_CHANNEL = "newChannel"
let CHANNEL_CREATED = "channelCreated"
let START_TYPE = "startType"
let STOP_TYPE = "stopType"
