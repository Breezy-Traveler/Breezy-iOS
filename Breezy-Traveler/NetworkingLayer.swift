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
    
    private let apiService = MoyaProvider<BTAPIEndPoints>()
    private let qodApiService = MoyaProvider<QODAPIEndPoint>()
    
    struct BTAPITripError: Error {
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
    
    func loadUserTrips(user: BTUser, callback: @escaping (Result<[Trip], BTAPITripError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.loadTrips(user)) { (result) in
            switch result {
                
            case .success(let response):
                
                switch response.statusCode {
                case 200:
                    guard let trips = try? JSONDecoder().decode([Trip].self, from: response.data) else {
                        return assertionFailure("JSON data not decodable")
                    }

                    callback(.success(trips))
                default:
                    let errors = BTAPITripError(errors: [String(describing: response)])
                    callback(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPITripError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    func createTrip(trip: Trip, callback: @escaping (Result<Trip, BTAPITripError>) -> ()) {
        apiService.request(.createTrip(trip)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let trip = try? JSONDecoder().decode(Trip.self, from: response.data) else {
                        return assertionFailure("JSON data not decodable")
                    }
                    
                    callback(.success(trip))
                default:
                    return assertionFailure("\(response.statusCode)")
                }
            case .failure(let err):
                let errors = BTAPITripError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    func deleteTrip(trip: Trip, callback: @escaping (Result<Trip, BTAPITripError>) -> ()) {
        apiService.request(.deleteTrip(trip)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 204:
                    
                    callback(.success(trip))
                default:
                    return assertionFailure("\(response.statusCode)")
                }
            
            case .failure(let err):
                let errors = BTAPITripError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    private let externalApiService = MoyaProvider<QODAPIEndPoint>()
  

}

extension NetworkStack {
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
    
    /*
     Register a user. User 'callback' to check if registering was successful or something went wrong. Then, check 'Errors' from the associated type of failure (e.g. invalid username/email/password or already taken username/email).
     
     - parameter user: user to register using username, email, and password
     */
    
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
}
    


    
extension NetworkStack {
    
    func getQuoteOfTheDay(callback: @escaping (Quote) -> ()) {
        qodApiService.request(.getQuote) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let json = try? JSON(data: response.data) else {
                        fatalError("No json")
                    
                    }
                    
                    let jsonContents = json["contents"]
                    let jsonQuote = jsonContents["quotes"][0]
                    guard let jsonQuoteData = try? jsonQuote.rawData() else {
                        fatalError("no json data")
                    }
                    
                    guard let quote = try? JSONDecoder().decode(Quote.self, from: jsonQuoteData) else {
                        fatalError("No quote")
                    }
//                    print(quote)
                    callback(quote)
                default:
                    return assertionFailure("\(response.statusCode)")
                }
                
            case .failure(let err):
                break
//                let errors = BTAPITripError(errors: [err.localizedDescription])
//                callback(.failure(errors))
            }
        }
    }
}






