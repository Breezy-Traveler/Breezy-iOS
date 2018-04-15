//
//  AlertVC.swift
//  Breezy-Traveler
//
//  Created by Breezy Traveler on 4/4/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import UIKit

struct AlertViewController {
    
    static func showWrongUsernameOrPAsswordAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Wrong username or password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
    
    static func showUserAlreadyRegisteredAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "User already registered with that username or email", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
    
    static func showNameAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Name can't be blank", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
    
    static func showUsernameAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Username can't be blank", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
    
    static func showEmailAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "invalid email address", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
    
    static func showPasswordAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "password have at least 6 characters", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
}
