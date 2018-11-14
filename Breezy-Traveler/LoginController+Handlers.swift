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
    
    /// When a user registers successfully, they are logged into the app
    @objc func handleRegister() {

        
        // Safely unwrap all input values from the user
        guard let name = nameTextField.text, name.count > 0 else {
            // popup an alert view that name can't be blank
            self.present(AlertViewController.showNameAlert(), animated: true, completion: nil)
            return
        }
        
        guard let username = usernameTextField.text, username.count > 0 else {
            // popup an alert view that user name can't be blank
            self.present(AlertViewController.showUsernameAlert(), animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, email.count > 0, email.isValidEmail() else {
            // popup an alert view that email is invalid
            self.present(AlertViewController.showEmailAlert(), animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text, password.isValidPassword() else {
            // popup an alert view that password is less than 6 characters
            self.present(AlertViewController.showPasswordAlert(), animated: true, completion: nil)
            return
        }

        // Set the criteria to register the user, and to log in the user
        let userRegister = UserRegister(username: username, password: password, email: email)
        
        // Ask the API to register the user
        networkStack.register(a: userRegister) { [weak self] (result) in
            
            // Unwrap the ViewController because we are in a closure
            guard let unwrappedSelf = self else { return }
            
            switch result {
                    
            // The user was registered into the database
            case .success(let registeredUser):
                unwrappedSelf.userPersistence.setCurrentUser(currentUser: registeredUser)
                unwrappedSelf.userPersistence.loginUser(username: userRegister.username, password: userRegister.password)
                
                // successfully logged in user
                unwrappedSelf.dismiss(animated: true, completion: nil)
                        
            case .failure(let err):
                unwrappedSelf.present(AlertViewController.showErrorAlert(message: err.localizedDescription), animated: true, completion: nil)
                
                debugPrint(err)
            }
        }
    }
}
