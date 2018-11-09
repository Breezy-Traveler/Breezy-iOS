//
//  UserModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/28/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

struct User: Codable {
    
    // MARK: - VARS
    
    let id: String
    
    struct LocalProvider: Codable {
        var token: String
        var email: String
        var username: String
    }
    var local: LocalProvider?
    
    struct Facebook: Codable {
        var id: String
        var token: String
        var email: String
        var name: String
    }
    var facebook: Facebook?
    
    struct Google: Codable {
        var id: String
        var token: String
        var email: String
        var name: String
    }
    var google: Google?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case local
        case facebook
        case google
    }
    
    var username: String {
        if let localUser = self.local {
            return localUser.username
        } else if let facebook = self.facebook {
            return facebook.name
        } else if let google = self.google {
            return google.name
        } else {
            assertionFailure("no user provider found")
            
            return "null"
        }
    }
    
    var email: String {
        if let localUser = self.local {
            return localUser.email
        } else if let facebook = self.facebook {
            return facebook.email
        } else if let google = self.google {
            return google.email
        } else {
            assertionFailure("no user provider found")
            
            return "null"
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
}

struct BTUser: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let token: String?
    let imageUrl: URL?
    let imageData: Data?
    
    
    static func getStoredUser() -> BTUser {
        let userPersistence = UserPersistence()
        guard let currentUser = userPersistence.getCurrentUser() else {

            // FIXME: crashing the app
            fatalError("No Current User Data")
        }
        return currentUser
    }
}

struct UserRegister: Codable {    
    let name: String
    let username: String
    let password: String
    let email: String
}

struct UserLogin: Codable {
    let username: String
    let password: String
}
