//
//  PersistenceUser.swift
//  Breezy-Traveler
//
//  Created by Breezy Traveler on 4/4/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import KeychainSwift

struct UserPersistence {
    
    private let usernameKey: String = "username"
    private let passwordKey: String = "password"
    private let tokenKey: String = "token"
    private let currentUserKey: String = "currentUser"
    
    func setCurrentUser(currentUser: BTUser) {
        let keychain = KeychainSwift()
        guard let currentUserData = try? JSONEncoder().encode(currentUser) else {
            fatalError("no current user")
        }
        keychain.set(currentUserData, forKey: currentUserKey)
        setUserToken(token: currentUser.token!)
    }
    
    func getCurrentUser() -> BTUser? {
        let keychain = KeychainSwift()
        guard let currentUserData = keychain.getData(currentUserKey), let currentUser = try? JSONDecoder().decode(BTUser.self, from: currentUserData) else {
            return nil
        }
        return currentUser
    }
    
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
    
    func setUserToken(token: String) {
        let keychain = KeychainSwift()
        keychain.set(token, forKey: tokenKey)
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
            case .success(let userReturned):
                self.setUserToken(token: userReturned.token!)
                callback(true)
            case .failure(let error):
                // FIXME: breaking here with bad credentials
                assertionFailure("bad user credentials \(error.localizedDescription)")
                callback(false)
            }
        }
    }
    
}
