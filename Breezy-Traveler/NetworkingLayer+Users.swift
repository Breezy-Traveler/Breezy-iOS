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
    
    struct BTAPIUserError: Error {
        var errors = [String]()
        
        var localizedDescription: String {
            
            /*
             Combine the list of errors in sentences
             Reduce takes an array and concatenates all the arguments
             $0 if the first argument, $1 is the second arg
             */
            return self.errors.reduce("", { $0 + "\($1)\n"} )
        }
    }
    
    
    // MARK: - User Login
    
    func register(a user: UserRegister, callback: @escaping (Result<BTUser, BTAPIUserError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.registerUser(user)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        return assertionFailure("JSON data not decodable")
                    }
                    
                    callback(.success(user))
                default:
                    return assertionFailure("\(response.statusCode)")
                }
            case .failure(let err):
                let errors = BTAPIUserError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    func login(a user: UserLogin, callback: @escaping (Result<BTUser, BTAPIUserError>) -> ()) {
        apiService.request(.loginUser(user)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        return assertionFailure("JSON data not decodable")
                    }
                    
                    callback(.success(user))
                default:
                    return assertionFailure("\(response.statusCode)")
                }
            case .failure(let err):
                let errors = BTAPIUserError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }

}





