//
//  LoginVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTf.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func pressedLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // hide the keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
