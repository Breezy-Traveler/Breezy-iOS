//
//  UserModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/28/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

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
