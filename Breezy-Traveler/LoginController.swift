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
    
    // MARK: - VARS
    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    
    // Get the initial width and height
    lazy var width: CGFloat = 0.0
    lazy var height: CGFloat = 0.0
    var inputContainerHeight: CGFloat?
    
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
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BreezyTravelerLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        //dissmiss keyboard with return key
        tf.addTarget(self, action: #selector(done(_:)), for: UIControlEvents.primaryActionTriggered)
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
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        //dissmiss keyboard with return key
        tf.addTarget(self, action: #selector(done(_:)), for: UIControlEvents.primaryActionTriggered)
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
        //dissmiss keyboard with return key
        tf.addTarget(self, action: #selector(done(_:)), for: UIControlEvents.primaryActionTriggered)
        return tf
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var usernameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func getScreenSizes() {
        // Get the initial width and height
        self.width = self.view.frame.width
        self.height = self.view.frame.height
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleLogin() {
        guard let username = try? usernameTextField.text.sanitizing(with: .notEmpty, .trimmed) else {
            return self.present(AlertViewController.showUsernameAlert(), animated: true, completion: nil)
        }
        
        guard let password = try? passwordTextField.text.sanitizing(with: .trimmed, .notEmpty, .longerThanOrEqual(to: 6)) else {
            return self.present(AlertViewController.showPasswordAlert(), animated: true, completion: nil)
        }
        
        let userLogin = UserLogin(username: username, password: password)
        
        let loading = LoadingViewController()
        loading.present()
        
        networkStack.login(a: userLogin) { [weak self] (result) in
            loading.dismiss {
                guard let unwrappedSelf = self else { return }
                
                switch result {
                case .success(let loggedInUser):
                    unwrappedSelf.userPersistence.login(loggedInUser)
                    
                    // successfully logged in user
                    unwrappedSelf.presentingViewController!.dismiss(animated: true)
                    
                case .failure(let err):
                    unwrappedSelf.presentAlert(
                        error: err,
                        title: "Loggin In"
                    )
                }
            }
        }
    }
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        // When the login active: perform a check if the user data is correct
        UIView.performWithoutAnimation { loginRegisterButton.setTitle(title, for: .normal) }
        
        
        // Change height of input container view
        guard let height = inputContainerHeight else {
            fatalError("No input containter height")
        }
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? height / 1.5 : height
        
        // Change height of usernameTextField
        usernameTextFieldHeightAnchor?.isActive = false
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        usernameTextFieldHeightAnchor?.isActive = true
        
        // Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func clearForms() {
        usernameTextField.text = nil
        passwordTextField.text = nil
        emailTextField.text = nil
    }
    
    func setupLogoImageView() {
        guard let height = inputContainerHeight else {
            fatalError("No inputs container height")
        }
        // Need x, y, width, and height contraints
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -16).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: height * 0.60).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: height * 0.60).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width, and height contraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(lessThanOrEqualToConstant: 36).isActive = true
        
    }
    
    func setUpContainerView() {
        getScreenSizes()
        // This will determine the sizes of all the views on the screen
        self.inputContainerHeight = self.height / 5
        guard let height = self.inputContainerHeight else {
            fatalError("No input container height")
        }
        // Constraints for the containerView x, y, width, and height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: height)
        inputContainerViewHeightAnchor?.isActive = true
        
        // All the subviews within the login Container View
        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(usernameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Contraints: x, y, width, and height of Name field
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        usernameTextFieldHeightAnchor?.isActive = true
        
        // Constraints for line below the Name
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Contraints: x, y, width, and height of Email field
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: usernameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Constraints for line below the email
        emailSeparatorView.leftAnchor.constraint(equalTo: usernameSeparatorView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Constrain x, y, width, and height of Password text field
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setUpLoginRegisterButton() {
        guard let height = inputContainerHeight else {
            fatalError("No inputs container height")
        }
        // Need x, y, width, and height contraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: height / 4).isActive = true
        
        // testing git
        loginRegisterButton.tintColor = UIColor.black
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImageView)
        
        setupLoginRegisterSegmentedControl()
        setUpContainerView()
        
        setUpLoginRegisterButton()
        setupLogoImageView()
        handleLoginRegisterChange()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.clearForms()
    }
}

