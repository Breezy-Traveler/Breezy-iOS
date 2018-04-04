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
    
    private let usernameKey: String = "username"
    private let passwordKey: String = "password"
    private let tokenKey: String = "token"
    
    func loginUser(username: String, password: String) {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: usernameKey)
        keychain.set(password, forKey: passwordKey)
        
    }
    
    func getUserLoginCredentials() -> (username: String, password: String)? {
        let keychain = KeychainSwift()
        guard let username = keychain.get(usernameKey), let password = keychain.get(passwordKey) else {
            return nil
        }
        return (username, password)
    }
    
    func getUserToken() -> String? {
        let keychain = KeychainSwift()
        guard let token = keychain.get(tokenKey) else {
            return nil
        }
        return token
    }
    
    func logoutUser() {
        let keychain = KeychainSwift()
        keychain.delete(usernameKey)
        keychain.delete(passwordKey)
        keychain.delete(tokenKey)
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
