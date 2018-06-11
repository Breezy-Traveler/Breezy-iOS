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
    func register(a user: UserRegister, callback: @escaping (Result<BTUser, UserErrorMessages>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.registerUser(user)) { (result) in
            
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserErrorMessages.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(user))
                case 422:
                    let errors = UserErrorMessages(dataValues: response.data)
                    callback(.failure(errors))
                    
                default:
                    let errors = UserErrorMessages.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserErrorMessages.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
    
    func login(a user: UserLogin, callback: @escaping (Result<BTUser, UserErrorMessages>) -> ()) {
        apiService.request(.loginUser(user)) { (result) in
            switch result {
            case .success(let response):
                
                // FIXME: handle 401 (invalid credentials)
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserErrorMessages.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    callback(.success(user))
                
                case 401:
                    let errors = UserErrorMessages.invalidCredentials()
                    callback(.failure(errors))
                    
                default:
                    let errors = UserErrorMessages.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserErrorMessages.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
}





