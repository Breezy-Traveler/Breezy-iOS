//
//  PersistenceUser.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/4/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import KeychainSwift

struct UserPersistence {
    
    func loginUser(username: String, password: String) {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: "username")
        keychain.set(password, forKey: "password")
        
    }
    
    func getUserLoginCredentials() -> (username: String, password: String)? {
        let keychain = KeychainSwift()
        guard let username = keychain.get("username"), let password = keychain.get("password") else {
            return nil
        }
        return (username, password)
    }
    
    func checkUserLoggedIn(callback: @escaping (Bool) -> ()) {
        
        let networkStack = NetworkStack()
//        let keychain = KeychainSwift()
        guard let userCredentials = getUserLoginCredentials() else {
            return callback(false)
        }
        
        let userLogin = UserLogin(username: userCredentials.username, password: userCredentials.password)

        networkStack.login(a: userLogin) { (result) in
            switch result {
            case .success:
                callback(true)
            case .failure(let error):
                assertionFailure("bad user credentials \(error.localizedDescription)")
                callback(false)
            }
        }
    }
    
}
