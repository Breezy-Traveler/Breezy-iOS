//
//  LoginVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
    }

    @IBAction func pressedLogin(_ sender: UIButton) {
        guard let username = userNameTf.text, let password = passwordTF.text else {
            fatalError("User info missing")
        }
        
        let user = UserLogin(username: username, password: password)
        
        networkStack.login(a: user) {[weak self] (result) in
            guard let unwrappedSelf = self else {
                return
            }
            switch result {
                
            case .success(let loggedInUser):
                print(loggedInUser)
                unwrappedSelf.userPersistence.setCurrentUser(currentUser: loggedInUser)
                unwrappedSelf.userPersistence.loginUser(username: user.username, password: user.password)

                
            case .failure(let userErrors):
                DispatchQueue.main.async {
                    unwrappedSelf.present(AlertViewController.showAlert(), animated: true, completion: nil)
                }
                print(userErrors.errors)
            }
        }
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        
    }
    
}

