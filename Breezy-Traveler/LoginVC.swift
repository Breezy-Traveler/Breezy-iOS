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
    
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedLogin(_ sender: UIButton) {
        guard let username = userNameTf.text, let password = passwordTF.text else {
            fatalError("User info missing")
        }
        
        let user = UserLogin(username: username, password: password)
        
        networkStack.login(a: user) { (result) in
            switch result {
                
            case .success(let user):
                print(user)
                
                // Go back to Login View Controller
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let userErrors):
                print(userErrors.errors)
            }
        }
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        
    }
    
}

