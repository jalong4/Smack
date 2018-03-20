//
//  AddChannelVC.swift
//  Smack
//
//  Created by Jim Long on 3/19/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var channelNameTxt: UITextField!
    @IBOutlet weak var channelDescriptionTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        channelNameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [.foregroundColor: smackPurplePlaceholder])
        channelDescriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [.foregroundColor: smackPurplePlaceholder])
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTap))
        bgView.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
        guard
            let name = channelNameTxt.text, name != "",
            let description = channelDescriptionTxt.text, description != ""
            else {
                return
            }
        
        spinner.startAnimating()
        MessageService.instance.addChannel(name: name, description: description, completion: { (success) in
            if success {
                self.spinner.stopAnimating()
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })

    }

}
