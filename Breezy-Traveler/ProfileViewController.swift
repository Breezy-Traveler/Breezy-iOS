//
//  ProfileViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import KeychainSwift


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Variables
    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    var currentUser = BTUser.getStoredUser()
    let imagePicker = UIImagePickerController()

    // Mark: IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // Views
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        imagePicker.delegate = self
        
        // Set the navigation bar appearence for the entire app
        let navigationBarAppearace = UINavigationBar.appearance()

        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(r: 61, g: 91, b: 151)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateLabels()
        setupimageViewProperties()
        setupTextProperties()
        imageView.setUserProfileImage(currentUser: currentUser)
    }
    

    lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    

    // Actions
    @objc func tapDetected() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pressedLogout(_ sender: UIBarButtonItem) {
        let userPersistence = UserPersistence()
        userPersistence.logoutUser()
        let loginViewController = LoginController()
        self.present(loginViewController, animated: false, completion: nil)
    }
    
    func updateLabels() {
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        fullnameLabel.text = currentUser.name
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
    
    /** displays a loading indicator when true, hidden when false */
    private var isUploadingUserAvatar: Bool {
        set {
            if newValue {
                loadingIndicator.startAnimating()
                loadingIndicator.isHidden = false
                imageView.alpha = 0.45
            } else {
                loadingIndicator.stopAnimating()
                loadingIndicator.isHidden = true
                imageView.alpha = 1
            }
        }
        get {
            return loadingIndicator.isAnimating
        }
    }

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
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("problem getting image")
        }
        
        let rotatedImage = fixOrientation(img: pickedImage)
        isUploadingUserAvatar = true
        
        userPersistence.updateUserProfileImage(image: rotatedImage, for: currentUser) { (user) in
            if let updatedUser = user {
                self.currentUser = updatedUser
                
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.image = pickedImage
                
                // Updating the user with the url of their profile image
                self.userPersistence.setCurrentUser(currentUser: updatedUser)
                
            } else {
                
                // display an alert view letting user know it failed
                let av = AlertViewController.showNoImageAlert()
                self.present(av, animated: true, completion: nil)
            }
            
            self.isUploadingUserAvatar = false
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
//            // FIXME: add a default image instead of throwing an error
//            fatalError("problem getting image")
//        }
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = pickedImage
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
