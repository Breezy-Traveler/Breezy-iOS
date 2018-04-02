//
//  RegisterVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    let networkStack = NetworkStack()
    
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        // Safely unwrap the input values from the user
        guard let name = fullnameTF.text, let username = usernameTF.text, let email = emailTF.text, let password = passwordTF.text else {
            
            // FIXME: Use an alertView to let user know there are missing fields
            fatalError("user fields missing some data")
        }
        
        let user = UserRegister(name: name, username: username, password: password, email: email)
        networkStack.register(a: user) { (result) in
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
    
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
