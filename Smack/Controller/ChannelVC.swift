//
//  ChannelVC.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(seque: UIStoryboardSegue){}
    
    @IBOutlet weak var userImg: CicrleImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        getUserData()
    }
    
    @objc func userDataDidChange(_ notif: Notification) {

        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.getAvatarColor()
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = #imageLiteral(resourceName: "menuProfileIcon")
            userImg.backgroundColor = .clear
        }
        loginBtn.isHidden = false
        userImg.isHidden = false
    }
    
    func getUserData() {
        
        let email = AuthService.instance.userEmail
        
        if email == "" { return }
        
        if AuthService.instance.isLoggedIn {
            loginBtn.isHidden = true
            userImg.isHidden = true
            AuthService.instance.findUser(email: email, completion: { (success) in
                if success {
                    print("User data retrieved for \(email)")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
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
}
