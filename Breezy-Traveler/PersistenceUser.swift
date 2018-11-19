//
//  PersistenceUser.swift
//  Breezy-Traveler
//
//  Created by Breezy Traveler on 4/4/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import KeychainSwift

class UserPersistence {
    
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
    
    private let currentUserKey: String = "currentUser"
    
    private var userProfileImageURL: URL {
        
        // Get the URL for where to save the image
        guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError("no access to this directory")
        }
        
        // Create a filepath name for the image store
        let url = libraryDirectory.appendingPathComponent("userProfile.png")
        
        return url
    }
    
    static var currentUser: User {
        guard let user = self._currentUser else {
            fatalError("no user logged in. Please ensure this property is not invoked without ensuring a user is logged in")
        }
        
        return user
    }
    
    static var currentUserIfLoggedIn: User? {
        return self._currentUser
    }
    
    static private var _currentUser: User?
    
    // MARK: - RETURN VALUES
    
    //load the user from persistence and return it
        //does user default contain USER_ALREADY_LOGGED_IN?
        //is user in keychains present and valid?
        //return user
    
        //otherwise, clear user, if stored, from keychains since user default doesn't contain key
    private func loadUser() -> User? {
        /**
         since deleting the app doesn't clear keychains, we must check if the user defaults
         contains USER_ALREADY_LOGGED_IN before we check the keychains in the event
         the user deletes the app.
         */
        
        let userDefaults = UserDefaults.standard
        let keychains = KeychainSwift()
        
        guard userDefaults.bool(forKey: currentUserKey) else {
            
            //clear user, if stored, from keychains since user default doesn't contain key
            self.removeUser()
            
            return nil
        }
        
        guard
            let userDataFromKeychains = keychains.getData(currentUserKey),
            let user = try? JSONDecoder().decode(User.self, from: userDataFromKeychains) else {
                
                //invalid user, clear the keychain and remove the key from user defaults
                self.removeUser()
                
                return nil
        }
        
        return user
    }
    
    // MARK: - METHODS
    
    //check if there is already a user persisted in user defaults
        //make a network call to validate their token?
        //store user in memory
    func checkIfUserIsLoggedIn() -> Bool {
        
        if let currentUser = self.loadUser() {
            self.setCurrentUser(currentUser)
            
            return true
            
            //TODO: validate using validate endpoint
//            let networkStack = NetworkStack()
//            networkStack.validate(currentUser, ...)
            
            //if validation failed, clear the user and invoke the callback with false
            //otherwise, store user in memory and invoke callback with true
        } else {
            
            return false
        }
    }
    
    func login(_ user: User) {
        self.setCurrentUser(user, writeToPersistence: true)
    }
    
    func logout() {
        self.removeUser()
    }
    
    //store the given User in persistence
        //store USER_ALREADY_LOGGED_IN true in user defaults
        //store user in Keychains since user contains token
    private func setCurrentUser(_ user: User, writeToPersistence: Bool = false) {
        
        UserPersistence._currentUser = user
        
        if writeToPersistence {
            let userDefaults = UserDefaults.standard
            let keychains = KeychainSwift()
            
            userDefaults.set(true, forKey: currentUserKey)
            
            do {
                let userData = try JSONEncoder().encode(user)
                keychains.set(userData, forKey: currentUserKey)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    //remove the user, if stored, from persistence
        //clear USER_ALREADY_LOGGED_IN from user defaults
    private func removeUser() {
        let userDefaults = UserDefaults.standard
        let keychains = KeychainSwift()
        
        userDefaults.set(nil, forKey: currentUserKey)
        keychains.delete(currentUserKey)
        
        self.userProfileImage = nil
    }
}
