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
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case local
        case facebook
        case profileImage
    }
    
    var username: String {
        if let localUser = self.local {
            return localUser.username
        } else if let facebook = self.facebook {
            return facebook.name
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
        } else {
            assertionFailure("no user provider found")
            
            return "null"
        }
    }
    
    var token: String {
        if let localUser = self.local {
            return localUser.token
        } else if let facebook = self.facebook {
            return facebook.token
        } else {
            assertionFailure("no user provider found")
            
            return "null"
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
}

extension User: Equatable {
    static func ==(_ lhs: User, _ rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserRegister: Codable {
    let username: String
    let password: String
    let email: String
}

struct UserLogin: Codable {
    let username: String
    let password: String
}
