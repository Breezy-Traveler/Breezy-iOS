//
//  ProfileViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Mark: IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    // Variables
    var currentUser = BTUser.getStoredUser()
    let imagePicker = UIImagePickerController()
    let userPersistence = UserPersistence()
    
    
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
       
        setupimageViewProperties()
        setupTextProperties()
        setupButtonProperties()
        
        if let storedImage = userPersistence.loadUserProfileImage() {
            imageView.image = storedImage
        }
        updateLabels()
    }
    
    // Button changes based on the segmented controller
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 148, g: 194, b: 61) // lime green color
        button.setTitle("Continue to your trips", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(contunueButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // FIXME: Change this func to navigate to MyTripsController
    @objc func contunueButtonPressed() {
        // Initialize the new storyboard in code,
        let storyboard = UIStoryboard(name: "Trips", bundle: nil)
        // Initialize the new view controller in code using a storyboard identifier
        let VC = storyboard.instantiateViewController(withIdentifier: "MyTripsViewController") as! MyTripsViewController
        // and then use the navigation controller to segue to it.
        self.navigationController?.pushViewController(VC, animated: true)
    }

    
    lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    
    
    // Actions
    @objc func tapDetected() {
        print("Imageview Clicked")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
           Add a stroke around the imageView
           Set the color to white */
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
    
    func setupButtonProperties() {
        continueButton.titleLabel?.textColor = UIColor.white
    }
    
    /**
     A UIImage has a property imageOrientation, which instructs the UIImageView
     and other UIImage consumers to rotate the raw image data.
     There's a good chance that this flag is being saved to the exif data in the
     uploaded jpeg image, but the program you use to view it is not honoring that flag.
     
     https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
     */
    private func fixOrientation(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img
        }
        
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
        
        let rotated = fixOrientation(img: pickedImage)
        
        userPersistence.storeUserProfileImage(image: rotated)
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
