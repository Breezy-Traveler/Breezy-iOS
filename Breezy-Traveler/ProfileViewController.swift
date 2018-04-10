//
//  ProfileViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentUser = BTUser.getStoredUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
    }
    
    let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
    
    
    //Action
    @objc func tapDetected() {
        print("Imageview Clicked")
    }



}
