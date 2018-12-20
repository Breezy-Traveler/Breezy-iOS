//
//  NetworkingLayer.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/29/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON


struct NetworkStack {
    
    private(set) var apiService = MoyaProvider<BTAPIEndPoints>()
    private(set) var qodApiService = MoyaProvider<QODAPIEndPoint>()
    
    // MARK: - User Login
    func register(a user: UserRegister, callback: @escaping (Result<User, UserfacingErrors>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.registerUser(user)) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(User.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(user))
                case 401:
                    let errors = UserfacingErrors(userData: response.data)
                    callback(.failure(errors))
                    
                default:
                    let errors = UserfacingErrors.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserfacingErrors.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
    
    func login(a user: UserLogin, callback: @escaping (Result<User, UserfacingErrors>) -> ()) {
        apiService.request(.loginUser(user)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 200:
                    guard let user = try? JSONDecoder().decode(User.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    callback(.success(user))
                
                case 401:
                    let errors = UserfacingErrors.invalidCredentials()
                    callback(.failure(errors))
                    
                default:
                    let errors = UserfacingErrors.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserfacingErrors.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
    
    func upload(profile image: UIImage, callback: @escaping (Result<UIImage, UserfacingErrors>) -> ()) {
        guard let imageData = UIImagePNGRepresentation(image) else {
            let err = UserfacingErrors.somethingWentWrong(message: "invalid image")
            
            return callback(.failure(err))
        }
        
        apiService.request(.uploadUserProfileImage(imageData: imageData)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 200:
                    guard let userImage = UIImage(data: response.data) else {
                        assertionFailure("could not decode into an image")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(userImage))
                    
                case 413:
                    let errors = UserfacingErrors.somethingWentWrong(message: "payload too large")
                    return callback(.failure(errors))
                    
                case 401:
                    let errors = UserfacingErrors.invalidCredentials()
                    callback(.failure(errors))
                    
                default:
                    let errors = UserfacingErrors.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserfacingErrors.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
    
    func clearProfileImage(callback: @escaping (Result<User, UserfacingErrors>) -> ()) {
        //TODO: erick-clear user profile image
    }
}





