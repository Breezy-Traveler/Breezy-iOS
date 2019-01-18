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
        guard let username = try? usernameTextField.text.sanitizing(with: .trimmed, .notEmpty) else {
            // popup an alert view that user name can't be blank
            self.present(AlertViewController.showUsernameAlert(), animated: true, completion: nil)
            return
        }
        
        guard let email = try? emailTextField.text.sanitizing(with: .trimmed, .notEmpty, .anEmail) else {
            // popup an alert view that email is invalid
            self.present(AlertViewController.showEmailAlert(), animated: true, completion: nil)
            return
        }
        
        guard let password = try? passwordTextField.text.sanitizing(with: .trimmed, .notEmpty, .longerThanOrEqual(to: 6)) else {
            // popup an alert view that password is less than 6 characters
            self.present(AlertViewController.showPasswordAlert(), animated: true, completion: nil)
            return
        }

        // Set the criteria to register the user, and to log in the user
        let userRegister = UserRegister(username: username, password: password, email: email)
        
        let loading = LoadingViewController()
        loading.present()
        
        // Ask the API to register the user
        networkStack.register(a: userRegister) { [weak self] (result) in
            loading.dismiss {
                
                // Unwrap the ViewController because we are in a closure
                guard let unwrappedSelf = self else { return }
                
                switch result {
                    
                // The user was registered into the database
                case .success(let registeredUser):
                    unwrappedSelf.userPersistence.login(registeredUser)
                    
                    // successfully logged in user
                    unwrappedSelf.dismiss(animated: true, completion: nil)
                    
                case .failure(let err):
                    unwrappedSelf.presentAlert(
                        error: err,
                        title: "Registering"
                    )
                }
            }
        }
    }
}
