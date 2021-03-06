//
//  ChannelVC.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(seque: UIStoryboardSegue){}
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 40
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 66
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelDataDidChange(_:)), name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
        
        setupUserInfo()
        findAllChannels()
        
        SocketService.instance.getChannel { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }
        
        SocketService.instance.getMessage { (message) in
            
            guard let message = message else { return }
            
            if message.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.insert(message.channelId)
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        revealViewController().frontViewController.view.endEditing(true)
        setupUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.getAvatarColor()
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = #imageLiteral(resourceName: "menuProfileIcon")
            userImg.backgroundColor = .clear
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    fileprivate func findAllChannels() {
        
        if !AuthService.instance.isLoggedIn { return }
        
        self.spinner.startAnimating()
        
        MessageService.instance.clearChannels()
        MessageService.instance.findAllChannels { (success) in
            if success {
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    @objc func channelDataDidChange(_ notif: Notification) {
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }

    @IBAction func addChannelPressed(_ sender: Any) {
        
        if !AuthService.instance.isLoggedIn { return }
        
        let addChannelVC = AddChannelVC()
        addChannelVC.modalPresentationStyle = .custom
        present(addChannelVC, animated: true, completion: nil)
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CHANNEL_CELL) as? ChannelCell
            else { return ChannelCell() }
        
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
        if MessageService.instance.unreadChannels.contains(channel.id) {
            MessageService.instance.unreadChannels.remove(channel.id)
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
