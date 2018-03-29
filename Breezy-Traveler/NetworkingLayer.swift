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
//import SwiftyJSON


struct NetworkStack {
    
    private let apiService = MoyaProvider<BTAPIEndPoints>()
    
    struct BTAPITripError: Error {
        var errors = [String]()
        
        var localizedDescription: String {
            
            // Combine the list of erros in sentences
            return self.errors.reduce("", { $0 + "\($1)\n"} )
        }
    }
    
    func loadUserTrips(user: BTUser, callback: @escaping (Result<String, BTAPITripError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.loadTrips(user)) { (result) in
            switch result {
                
            case .success(let response):
                break
            case .failure(let err):
                let errors = BTAPITripError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    // MARK: - User Login
    
    /*
    Register a user. User 'callback' to check if registering was successful or something went wrong. Then, check 'Errors' from the associated type of failure (e.g. invalid username/email/password or already taken username/email).
     
     - parameter user: user to register using username, email, and password
    */
    
//    func register (a user: BTUser, callback: @escaping (Result<String, BTAPIUserError>) -> ()) {
//        /// handles the response data after the networkService has fired and come back with a result
//
//    }
}
    







