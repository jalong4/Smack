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
    @IBOutlet weak var userImg: CicrleImage!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 40
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        setupUserInfo()
        findAllChannels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserInfo()
    }
    
    fileprivate func findAllChannels() {
        
        if !AuthService.instance.isLoggedIn { return }
        
        self.spinner.startAnimating()
        
        MessageService.instance.clearChannels()
        MessageService.instance.findAllChannels { (success) in
            if success {
                self.spinner.stopAnimating()
                self.tableview.reloadData()
                
            }
        }
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
        tableview.reloadData()
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
        cell.configureCell(name: channel.name)
        return cell
    }
}
