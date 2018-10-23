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
    private var _avatarUrl: String
    var avatarUrl: URL? {
        set {
            if let newUrl = newValue {
                self._avatarUrl = newUrl.absoluteString
            } else {
                self._avatarUrl = "/avatars/original/missing.png"
            }
        }
        get {
            if self._avatarUrl == "/avatars/original/missing.png" || self._avatarUrl == "" {
                return nil
            } else {
                return URL(string: self._avatarUrl)
            }
        }
    }
    
    var avatar: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
        case token
        case _avatarUrl = "avatar_url"
        case avatar
    }
    
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
