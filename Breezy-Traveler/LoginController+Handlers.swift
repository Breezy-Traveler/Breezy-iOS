//
//  LoginController+Handlers.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        
        guard let name = nameTextField.text, let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            // FIXME: Use an alertView to let user know there are missing fields
            fatalError("Form is not valid, missing some fields")
        }
        
        // Safely unwrap the input values from the user
        let userRegister = UserRegister(name: name, username: username, password: password, email: email)
        let userLogin = UserLogin(username: username, password: password)
        networkStack.register(a: userRegister) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            switch result {
                case .success:
                
                // Auto login the user and navigate to the MyTripsView
                    unwrappedSelf.networkStack.login(a: userLogin) { (result) in
                        switch result {
                            
                            case .success(let loggedInUser):
                                print(loggedInUser)
                                unwrappedSelf.userPersistence.setCurrentUser(currentUser: loggedInUser)
                                unwrappedSelf.userPersistence.loginUser(username: userLogin.username, password: userLogin.password)
                                
                                // successfully logged in user
                                unwrappedSelf.dismiss(animated: true, completion: nil)
                            
                            case .failure(let userErrors):
                                DispatchQueue.main.async {
                                    unwrappedSelf.present(AlertViewController.showAlert(), animated: true, completion: nil)
                                }
                            print(userErrors.errors)
                        }
                }
                case .failure:
                    DispatchQueue.main.async {
                        unwrappedSelf.present(AlertViewController.showAlert(), animated: true, completion: nil)
                    }
            }
        }
            
    }
}
    
    private func registerUserIntoDatabase(uid: String, values: [String: AnyObject]) {
//        let ref = Database.database().reference(fromURL: "https://unicornchats.firebaseio.com/")
//        let usersReference = ref.child("users").child(uid)
//
//        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//            if err != nil {
//                print(err!)
//                return
//            }
//            // Dissmiss view controller to view the appication
//            // Saved user successfully into Firebase db
//            self.dismiss(animated: true, completion: nil)
//        })

    
//    @objc func handleSelectProfileImageView() {
//        // allow users to select image from their photo library
//        let picker = UIImagePickerController()
//
//        picker.delegate = self
//        picker.allowsEditing = true
//
//        present(picker, animated: true, completion: nil)
//    }

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImageFromPicker = originalImage
//
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            profileImageView.image = selectedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("\ncanceled picker\n")
//        dismiss(animated: true, completion: nil)
    }


