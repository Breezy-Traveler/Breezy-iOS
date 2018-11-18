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
    
    func setCurrentUser(currentUser: User) {
        let keychain = KeychainSwift()
        guard let currentUserData = try? JSONEncoder().encode(currentUser) else {
            fatalError("no current user")
        }
        keychain.set(currentUserData, forKey: currentUserKey)
        
        // FIXME: Refactor this, function not really needed
        // CurrentUserData includes token property
        setUserToken(token: currentUser.token)
    }
    
    func getCurrentUser() -> User? {
        let keychain = KeychainSwift()
        guard let currentUserData = keychain.getData(currentUserKey), let currentUser = try? JSONDecoder().decode(User.self, from: currentUserData) else {
            return nil
        }
        return currentUser
    } //computed var
    
    func loginUser(username: String, password: String) {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: usernameKey)
        keychain.set(password, forKey: passwordKey)
    } //no need to store credintials
    
    func getUserLoginCredentials() -> (username: String, password: String)? {
        let keychain = KeychainSwift()
        guard let username = keychain.get(usernameKey), let password = keychain.get(passwordKey) else {
            return nil
        }
        return (username, password)
    } //not needed after using token to validate current user
    
    func setUserToken(token: String) {
        let keychain = KeychainSwift()
        keychain.set(token, forKey: tokenKey)
    } //user login
    
    func getUserToken() -> String? {
        let keychain = KeychainSwift()
        guard let token = keychain.get(tokenKey) else {
            return nil
        }
        return token
    } //from current user
    
    mutating func logoutUser() {
        let keychain = KeychainSwift()
        keychain.delete(usernameKey)
        keychain.delete(passwordKey)
        keychain.delete(tokenKey)
        
        self.userProfileImage = nil
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
                self.setUserToken(token: userReturned.token)
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }
    
    // MARK: - VARS
    
    var userProfileImage: UIImage? {
        set {
            if let newImage = newValue {
                let url = userProfileImageURL
                
                // Convert the UIImage into Data
                guard let imageData = UIImagePNGRepresentation(newImage) else {
                    return assertionFailure("failed to create data from image")
                }
                
                // Use file manager to save the data
                do {
                    try imageData.write(to: url)
                } catch {
                    assertionFailure("\(error)")
                }
            } else {
                
                //try to delete image from storage
                try? FileManager.default.removeItem(at: userProfileImageURL)
            }
        }
        
        get {
            guard let imageData = try? Data(contentsOf: userProfileImageURL) else {
                return nil
            }
            
            if let image = UIImage(data: imageData) {
                return image
            } else {
                assertionFailure("image not converted from data")
                
                return nil
            }
        }
    }
    
    private let usernameKey: String = "username"
    private let passwordKey: String = "password"
    private let tokenKey: String = "token"
    private let currentUserKey: String = "currentUser"
    
    private var userProfileImageURL: URL {
        
        // Get the URL for where to save the image
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError("no access to this directory")
        }
        
        // Create a filepath name for the image store
        let url = libraryDirectory.appendingPathComponent("userProfile.png")
        
        return url
    } //keep
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    static private(set) var currentUser: User!
    
    //check if there is already a user persisted in user defaults
        //make a network call to validate their token?
        //store user in memory
    
    //store the given User in persistence
        //store USER_ALREADY_LOGGED_IN true in user defaults
        //store user in Keychains since user contains token
    
    //load the user from persistence (private?)
        //does user default contain USER_ALREADY_LOGGED_IN?
        //is user in keychains present and valid?
        //return user
    
        //otherwise, clear user, if stored, from keychains since user default doesn't contain key
    
    //remove the user, if stored, from persistence
        //clear USER_ALREADY_LOGGED_IN from user defaults
    
}
