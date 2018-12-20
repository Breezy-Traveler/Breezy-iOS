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
    
    func updateUserProfileImage(_ image: UIImage?, completion: @escaping (Bool) -> Void) {
        let networking = NetworkStack()
        
        if let image = image {
            guard let scaledImage = image.resize(to: CGSize.userProfileSize) else {
                assertionFailure("Failed to resize image")
                
                return completion(false)
            }
            
            networking.upload(profile: scaledImage) { result in
                switch result {
                case .success(let updatedUser):
                    self.setCurrentUser(updatedUser, writeToPersistence: true)
                    completion(true)
                case .failure(let err):
                    assertionFailure(err.localizedDescription)
                    
                    completion(false)
                }
            }
        } else {
            //TODO: erick-clear user profile image
            
            //TODO: clear kingfisher cache (mabye don't need to clear cache when image changes)
//            networking.clearProfileImage { result in
//
//            }
        }
    }
    
    private let currentUserKey: String = "currentUser"
    
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
        
        //notify the user has been logged out
        NotificationCenter.default.post(name: NSNotification.Name.userDidLogout, object: nil)
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
    }
}

extension NSNotification.Name {
    static let userDidLogout = NSNotification.Name.init("USER_DID_LOGOUT")
}

extension CGSize {
    static let userProfileSize = CGSize(width: 512, height: 512)
}
