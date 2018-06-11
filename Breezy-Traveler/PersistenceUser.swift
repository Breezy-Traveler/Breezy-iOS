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
    
    var userProfileURL: URL = {
        // Get the URL for where to save the image
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError("no access to this directory")
        }
        // Create a filepath name for the image store
        let userProfileURL = libraryDirectory.appendingPathComponent("userProfile.png")
        return userProfileURL
    }()
    
    func storeUserProfileImage(image: UIImage) {
        
        // Convert the UIImage into Data
        guard let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        // Use file manager to save the data
        
        do {
            try imageData.write(to: userProfileURL)
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func removeUserProfileImage() {
        let filemanager = FileManager.default
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError("no access to this directory")
        }
        let userProfileImageURL = libraryDirectory.appendingPathComponent("userProfile.png")
        
        try? filemanager.removeItem(at: userProfileImageURL)
    }
    
    func loadUserProfileImage() -> UIImage? {
        guard let imageData = try? Data(contentsOf: userProfileURL) else {
            return nil
        }
        
        if let image = UIImage(data: imageData) {
            return image
        } else {
            print("image not converted from data")
            return nil
        }
    }
    
    func setCurrentUser(currentUser: BTUser) {
        let keychain = KeychainSwift()
        guard let currentUserData = try? JSONEncoder().encode(currentUser) else {
            fatalError("no current user")
        }
        keychain.set(currentUserData, forKey: currentUserKey)
        
        // FIXME: Refactor this, function not really needed
        // CurrentUserData includes token property
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

        //FIXME: don't perform network call if token exists
        let userLogin = UserLogin(username: userCredentials.username, password: userCredentials.password)

        networkStack.login(a: userLogin) { (result) in
            switch result {
            case .success(let userReturned):
                self.setUserToken(token: userReturned.token!)
                callback(true)
            case .failure(let error):
                
                // FIXME: breaking here with bad credentials
//                assertionFailure("bad user credentials \(error.localizedDescription)")
                callback(false)
            }
        }
    }
    
}
