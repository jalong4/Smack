//
//  LoginVC.swift
//  Smack
//
//  Created by Jim Long on 3/17/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [.foregroundColor: smackPurplePlaceholder])
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func performLogin() {
        dismiss(animated: true, completion: nil)
        guard
            let email = emailTxt.text, Utils.isEmailValid(email),
            let password = passwordTxt.text, Utils.isPasswordValid(password)
            else {
                return
        }
        
        spinner.startAnimating()
        dismiss(animated: true, completion: nil)
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        self.spinner.stopAnimating()
                        print("\(email) is now logged in")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }

    @IBAction func loginPressed(_ sender: Any) {
        performLogin()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField.tag == 1  { // email
            passwordTxt.becomeFirstResponder()
        } else {
            performLogin()
        }
        return true
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
