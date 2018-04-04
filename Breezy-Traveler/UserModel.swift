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
//    let password: String
    let email: String
    let token: String?
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
