//
//  ProfileViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentUser = BTUser.getStoredUser()
    let imagePicker = UIImagePickerController()
    let userPersistence = UserPersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        if let storedImage = userPersistence.loadUserProfileImage() {
            imageView.image = storedImage
        }
    }
    
    lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    
    
    // Action
    @objc func tapDetected() {
        print("Imageview Clicked")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("problem getting image")
        }
        userPersistence.storeUserProfileImage(image: pickedImage)
        imageView.contentMode = .scaleAspectFill
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("problem getting image")
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
