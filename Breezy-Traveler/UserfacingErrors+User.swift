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
        guard let errorValues = try? JSONDecoder().decode([String: String].self, from: userData) else {
            self.errors = []
            
            return
        }
        
        self.errors = []
        
        if let errorMessage = errorValues["Error"] {
            self.errors.append(errorMessage)
        }
    }
}
