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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        getUserData()
        MessageService.instance.findAllChannels { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            }
            
        }
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

}
