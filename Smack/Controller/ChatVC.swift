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
    @IBOutlet weak var messageTxtBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.onChannelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)

        getUserData()

    }
    
    func getUserData() {
        
        if !AuthService.instance.isLoggedIn { return }
        let email = AuthService.instance.userEmail
        
        AuthService.instance.findUserByEmail(completion: { (success) in
            if success {
                print("User data retrieved for \(email)")
            }
        })
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func onChannelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let name = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(name)"
        getMessages()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        
        if !AuthService.instance.isLoggedIn { return }
        
        guard
            let channelId = MessageService.instance.selectedChannel?.id,
            let message = messageTxtBox.text,
            !message.isEmpty
        else { return }
        
        SocketService.instance.addMessage(messageBody: message, channelId: channelId) { (success) in
            if success {
                self.messageTxtBox.text = nil
                self.view.endEditing(true)
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    func onLoginGetMessages() {

        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels.first
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages () {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        MessageService.instance.findAllMessages(for: channelId, completion: { (success) in
            if success {
                
            }
        })
    }

}
