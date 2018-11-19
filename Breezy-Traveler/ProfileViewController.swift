//
//  ProfileViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - VARS
    
    let networkStack = NetworkStack()
    var userPersistence = UserPersistence()
    let imagePicker = UIImagePickerController()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    private func updateUI() {
        if let storedImage = userPersistence.userProfileImage {
            imageView.image = storedImage
        }
        
        let user = UserPersistence.currentUser
        usernameLabel.text = user.username
        emailLabel.text = user.email
        fullnameLabel.text = user.username
    }
    
    func setupTextProperties() {
        usernameLabel.textColor = UIColor.white
        emailLabel.textColor = UIColor.white
        fullnameLabel.textColor = UIColor.white
    }
    
    func setupimageViewProperties() {
        /* Set the imageView to a circle
         Add a border around the imageView
         Set the color to white */
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @objc func tapDetected() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pressedLogout(_ sender: UIBarButtonItem) {
        userPersistence.logout()
        let loginViewController = LoginController()
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        imagePicker.delegate = self
        
        setupimageViewProperties()
        setupTextProperties()
        
        // Set the navigation bar appearence for the entire app
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(r: 61, g: 91, b: 151)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateUI()
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ProfileViewController {
    
    // Fixes the orientation of the profile image
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImageOrientation.up) { return img }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("problem getting image")
        }
        
        let rotatedImage = fixOrientation(img: pickedImage)
        
        userPersistence.userProfileImage = rotatedImage
        imageView.contentMode = .scaleAspectFill
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            // FIXME: add a default image instead of throwing an error
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
