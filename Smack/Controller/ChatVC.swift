//
//  ChatVC.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    var originalConstraint: CGFloat = 0.0
    var isTyping = false
    
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self

        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
        sendBtn.isHidden = true
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.onChannelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.idleTimerExpired(_:)), name: NOTIF_TIMER_EXPIRED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        originalConstraint = textFieldBottomConstraint.constant
        
        
        messageTxtBox.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)

        
        SocketService.instance.getMessage { (message) in
            
            guard
                let selectedChannelId = MessageService.instance.selectedChannel?.id,
                let message = message
                else {
                    return
            }
            
            if message.channelId == selectedChannelId && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(message)

                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    if MessageService.instance.messages.count > 0 {
                        let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                        self.tableview.scrollToRow(at: endIndex, at: .bottom, animated: false)
                    }
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id, AuthService.instance.isLoggedIn else { return }
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                if typingUser == UserDataService.instance.name || channel != channelId { continue }
                names = (names == "") ? typingUser : "\(names), \(typingUser)"
                numberOfTypers += 1
            }

            let verb = numberOfTypers > 1 ? "are" : "is"
            DispatchQueue.main.async {
                self.typingUsersLbl.text = numberOfTypers > 0 ? "\(names) \(verb) typing a message" : nil
            }
            
        }
        
        getUserData()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getUserData() {
        
        if !AuthService.instance.isLoggedIn {
            channelNameLbl.text = "Please Log In"
            return
        }
        
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
    
    @objc func idleTimerExpired(_ notif: Notification) {
        print("Inactivity timer expired")
        setTypingStopped()
    }
    
    @objc func keyboardWillShow(notification: Notification) {

        guard let info = notification.userInfo else { return }
        
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = info[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = curFrame.origin.y - targetFrame.origin.y - view.safeAreaInsets.bottom

        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.textFieldBottomConstraint.constant += deltaY

        },completion: {(true) in
            self.view.layoutIfNeeded()
        })
    }

    @objc func keyboardWillHide(notification: Notification) {

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.textFieldBottomConstraint.constant = self.originalConstraint
        }
    }

    
    func updateWithChannel() {
        DispatchQueue.main.async {
            let name = MessageService.instance.selectedChannel?.name ?? ""
            self.channelNameLbl.text = "#\(name)"
            self.typingUsersLbl.text = nil
        }
        getMessages()
    }
    
    func setTypingStopped() {
        isTyping = false
        sendBtn.isHidden = true
        TimerService.instance.cancelIdleTimer()
        SocketService.instance.socket.emit(STOP_TYPE, UserDataService.instance.name)
    }
    @IBAction func messageBoxEditting(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        if messageTxtBox.text == "" {
            setTypingStopped()
        } else {
            isTyping = true
            sendBtn.isHidden = false
            TimerService.instance.resetIdleTimer()
            SocketService.instance.socket.emit(START_TYPE, UserDataService.instance.name, channelId)
        }
    }
    
    func sendMessage() {
        if !AuthService.instance.isLoggedIn { return }
        
        guard
            let channelId = MessageService.instance.selectedChannel?.id,
            let message = messageTxtBox.text,
            !message.isEmpty
            else {
                TimerService.instance.cancelIdleTimer()
                return
            }
        
        SocketService.instance.addMessage(messageBody: message, channelId: channelId) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.messageTxtBox.text = ""
                    self.setTypingStopped()
                    self.view.endEditing(true)
                }
            }
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        sendMessage()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTxtBox.resignFirstResponder()
        sendMessage()
        return true
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            DispatchQueue.main.async {
                self.channelNameLbl.text = "Please Log In"
                self.tableview.reloadData()
            }
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
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    if MessageService.instance.messages.count > 0 {
                        let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                        self.tableview.scrollToRow(at: endIndex, at: .bottom, animated: false)
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MESSAGE_CELL) as? MessageCell
            else { return MessageCell() }
        
        if MessageService.instance.messages.isEmpty {  // in case messages are cleared in middle of reloadData
            return MessageCell()
        }
        
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }

}
