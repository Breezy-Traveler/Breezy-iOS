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
