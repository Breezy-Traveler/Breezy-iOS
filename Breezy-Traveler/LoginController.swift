//
//  ProgrammaticLogin.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift

class LoginController: UIViewController {
    
    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    
    // Create the container for user input
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // Must set this property for the anchors to work
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    // Button changes based on the segmented controller
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.backgroundColor = UIColor(r: 210, g: 59, b: 124) // pink color
        button.backgroundColor = UIColor(r: 148, g: 194, b: 61) // lime green color
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLoginRegister() {
//        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
//            handleLogin()
//        } else {
//            handleRegister()
//        }
    }
    
    @objc func handleLogin() {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            fatalError("Invalid form")
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
                
                // Go back to Trips ViewController
                // successfully logged in user
                unwrappedSelf.dismiss(animated: true, completion: nil)
                
            case .failure(let userErrors):
                DispatchQueue.main.async {
                    unwrappedSelf.present(AlertViewController.showAlert(), animated: true, completion: nil)
                }
                print(userErrors.errors)
            }
        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        // mask the text when the user types
        tf.isSecureTextEntry = true
        return tf
    }()

//    func pressedLogin(_ sender: UIButton) {
//        guard let username = userNameTf.text, let password = passwordTF.text else {
//            fatalError("User info missing")
//        }
//
//        let user = UserLogin(username: username, password: password)
//
//        networkStack.login(a: user) {[weak self] (result) in
//            guard let unwrappedSelf = self else {
//                return
//            }
//            switch result {
//
//            case .success(let loggedInUser):
//                print(loggedInUser)
//                unwrappedSelf.userPersistence.setCurrentUser(currentUser: loggedInUser)
//                unwrappedSelf.userPersistence.loginUser(username: user.username, password: user.password)
//
//                // Go back to Login View Controller
//                DispatchQueue.main.async {
//                    unwrappedSelf.presentingViewController!.dismiss(animated: true, completion: nil)
//                }
//
//            case .failure(let userErrors):
//                DispatchQueue.main.async {
//                    unwrappedSelf.present(AlertViewController.showAlert(), animated: true, completion: nil)
//                }
//                print(userErrors.errors)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
//        view.addSubview(loginRegisterButton)
//        view.addSubview(profileImageView)
//        view.addSubview(loginRegisterSegmentedControl)
//
        setUpContainerView()
//        setUpLoginRegisterButton()
//        setupProfileImageView()
//        setupLoginRegisterSegmentedControl()
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var usernameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setUpContainerView() {
        // Constraints for the containerView x, y, width, and height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 180)
        inputContainerViewHeightAnchor?.isActive = true
        
        // All the subviews within the login Container View
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(usernameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        // Contraints: x, y, width, and height of Name field
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Constraints for line below the Name
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Contraints: x, y, width, and height of Name field
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        usernameTextFieldHeightAnchor?.isActive = true
        
        // Constraints for line below the Name
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Contraints: x, y, width, and height of Email field
        emailTextField.leftAnchor.constraint(equalTo: usernameTextField.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: usernameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Constraints for line below the email
        emailSeparatorView.leftAnchor.constraint(equalTo: usernameSeparatorView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Constrain x, y, width, and height of Password text field
        passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
}

