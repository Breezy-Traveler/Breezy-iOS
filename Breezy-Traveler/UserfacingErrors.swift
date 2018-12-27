//
//  NetworkingErrors.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserfacingErrors: Error {
    
    var errors: [String]
    
    var localizedDescription: String {
        guard self.errors.count > 0 else { return "" }
        
        var errorMessage = ""
        
        errorMessage += self.errors.joined(separator: ", ")
        
        return errorMessage
    }
    
    static func somethingWentWrong(message: String = "something went wrong") -> UserfacingErrors {
        return UserfacingErrors(errors: [message])
    }
    
    static func serverError(message: Data) -> UserfacingErrors {
        return UserfacingErrors(dataErrorMessage: message)
    }
    
    static func duplicateAccount() -> UserfacingErrors {
        return UserfacingErrors(errors: ["Account already exists"])
    }
    
    init(errors: [String]) {
        self.errors = errors
    }
    
    /**
     - parameter dataErrorMessage: a encoded json containing either a string error,
     dictionary containing string errors, an array with string errors, or a combination
     
     - postcondition: will generate errors as `.ServerError(String)`
     */
    private init(dataErrorMessage: Data) {
        guard let jsonValues = try? JSON(data: dataErrorMessage) else {
            self.errors = []
            
            return
        }
        
        var errors = [String]()
        
        if let _ = jsonValues.dictionaryObject {
            
        } else if let _ = jsonValues.arrayObject {
            
        } else if let string = jsonValues.string {
            errors.append(string)
        }
        
        self.errors = errors
    }
}
