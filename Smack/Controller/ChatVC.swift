//
//  ChatVC.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.onChannelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        getUserData()

    }
    
    func getUserData() {
        
        if !AuthService.instance.isLoggedIn { return }
        let email = AuthService.instance.userEmail
        
        AuthService.instance.findUserByEmail(completion: { (success) in
            if success {
                print("User data retrieved for \(email)")
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        })
    }
    
    @objc func onChannelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let name = MessageService.instance.selectedChannel?.name ?? "Smack"
        channelNameLbl.text = "#\(name)"
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    func onLoginGetMessages() {
        updateWithChannel()
        MessageService.instance.findAllChannels { (success) in
            if success {

            }
        }
    }

}
