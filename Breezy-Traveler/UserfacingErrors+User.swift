//
//  UserfacingErrors+User.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

extension UserfacingErrors {
    
    static func invalidCredentials() -> UserfacingErrors {
        return UserfacingErrors(errors: ["invalid credentials"])
    }
    
    /**
     - parameter dataValues: a encoded json containing a string dictionary with
     values of array which contain strings
     */
    init(userData: Data) {
        guard let errorValues = try? JSONDecoder().decode([String: [String]].self, from: userData) else {
            self.errors = []
            
            return
        }
        
        var errors = [String]()
        
        if let emailError = errorValues["email"] {
            if emailError.contains("has already been taken") {
                errors.append("email already taken")
            }
        }
        
        if let usernameError = errorValues["username"] {
            if usernameError.contains("has already been taken") {
                errors.append("username already taken")
            }
        }
        
        self.errors = errors
    }
}
