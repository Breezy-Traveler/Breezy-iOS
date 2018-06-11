//
//  NetworkingErrors.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate enum UserErrors: Error {
    case SomethingWentWrong(String)
    case ServerError(String)
    
    case InvalidCredentials
    case UsernameAlreadyTaken
    case EmailAlreadyTaken
    
    var localizedDescription: String {
        switch self {
        case .SomethingWentWrong(let message):
            return message
        case .ServerError(let message):
            return "server error (\(message))"
        case .InvalidCredentials:
            return "invalid credentials"
        case .UsernameAlreadyTaken:
            return "username already taken"
        case .EmailAlreadyTaken:
            return "email already taken"
        }
    }
}

struct UserErrorMessages: Error, CustomStringConvertible {
    
    private var errors: [UserErrors]
    
    var localizedDescription: String {
        return self.description
    }
    
    var description: String {
        guard self.errors.count > 0 else { return "" }
        
        var errorMessage = ""
        
        let errorMessages = self.errors.map { $0.localizedDescription }
        errorMessage += errorMessages.joined(separator: ", ")
        
        return errorMessage
    }
    
    static func somethingWentWrong(message: String = "something went wrong") -> UserErrorMessages {
        return UserErrorMessages(errors: [UserErrors.SomethingWentWrong(message)])
    }
    
    static func serverError(message: String? = nil) -> UserErrorMessages {
        if let message = message {
            return UserErrorMessages(errors: [UserErrors.ServerError(message)])
        } else {
            return UserErrorMessages(errors: [UserErrors.ServerError("something went wrong")])
        }
    }
    
    static func serverError(message: Data) -> UserErrorMessages {
        return UserErrorMessages(dataErrorMessage: message)
    }
    
    static func invalidCredentials() -> UserErrorMessages {
        return UserErrorMessages(errors: [UserErrors.InvalidCredentials])
    }
    
    private init(errors: [UserErrors]) {
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
        
        var errors = [UserErrors]()
        
        if let _ = jsonValues.dictionaryObject {
            
        } else if let _ = jsonValues.arrayObject {
            
        } else if let string = jsonValues.string {
            errors.append(.ServerError(string))
        }
        
        self.errors = errors
    }
}

extension UserErrorMessages {
    
    /**
     - parameter dataValues: a encoded json containing a string dictionary with
     values of array which contain strings
     */
    init(dataValues: Data) {
        guard let errorValues = try? JSONDecoder().decode([String: [String]].self, from: dataValues) else {
            self.errors = []
            
            return
        }
        
        var errors = [UserErrors]()
        
        if let emailError = errorValues["email"] {
            if emailError.contains("has already been taken") {
                errors.append(UserErrors.EmailAlreadyTaken)
            }
        }
        
        if let usernameError = errorValues["username"] {
            if usernameError.contains("has already been taken") {
                errors.append(UserErrors.UsernameAlreadyTaken)
            }
        }
        
        
        self.errors = errors
    }
}
