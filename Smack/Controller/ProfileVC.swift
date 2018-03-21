//
//  ProfileVC.swift
//  Smack
//
//  Created by Jim Long on 3/19/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        profileImg.backgroundColor = UserDataService.instance.getAvatarColor()
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        username.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        bgView.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        dismiss(animated: true, completion: nil)
        
    }
}
