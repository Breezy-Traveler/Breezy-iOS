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
    
    static func showAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Wrong username or password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
}
