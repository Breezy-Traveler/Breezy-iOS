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
    
    lazy var networkStack = NetworkStack()
    lazy var userPersistence = UserPersistence()
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        /** this blocks the main thread for about 1 second */
        picker.delegate = self
        
        return picker
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
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBAction func pressedLogout(_ sender: UIBarButtonItem) {
        userPersistence.logout()
        
        if let presentingVc = self.navigationController?.presentingViewController {
            presentingVc.dismiss(animated: true)
        } else {
            let loginVc = LoginController()
            self.present(loginVc, animated: true)
        }
    }
    
    @IBAction func pressedUpdateProfileImage(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
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
