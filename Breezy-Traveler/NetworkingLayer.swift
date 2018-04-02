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
    
    struct BTAPITripError: Error {
        var errors = [String]()
        
        var localizedDescription: String {
            
            /*
             Combine the list of erros in sentences
             Reduce takes an array and concatenates all the arguments
             $0 if the first argument, $1 is the second arg
            */
            return self.errors.reduce("", { $0 + "\($1)\n"} )
        }
    }
    
    func loadUserTrips(user: BTUser, callback: @escaping (Result<[BTTrip], BTAPITripError>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.loadTrips(user)) { (result) in
            switch result {
                
            case .success(let response):
                
                switch response.statusCode {
                case 200:
                    guard let trips = try? JSONDecoder().decode([BTTrip].self, from: response.data) else {
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
    
    func createTrip(trip: BTTrip, callback: @escaping (Result<BTTrip, BTAPITripError>) -> ()) {
        apiService.request(.createTrip(trip)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let trip = try? JSONDecoder().decode(BTTrip.self, from: response.data) else {
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
    
    func deleteTrip(trip: BTTrip, callback: @escaping (Result<BTTrip, BTAPITripError>) -> ()) {
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
    
//    func getQuoteOfTheDay(callback: @escaping (String) -> ()) {
//        externalApiService.request(.getQuote) { (result) in
//            switch result {
//            case .success(let response):
//                switch response.statusCode {
//                    case 200:
//                        guard let quote = resp
//                        callback()
//                default:
//                   return assertionFailure("\(response.statusCode)")
//                    }
//            case .failure(let err):
//                let errors = BTAPITripError(errors: [err.localizedDescription])
//                callback(.failure(errors))
//                }
//            }
//
//        }
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

extension NetworkStack {
    func create(a hotel: BTHotel, for trip: BTTrip, callback: @escaping (Result<BTHotel, BTAPITripError>) -> ()) {
        apiService.request(.createHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedHotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        fatalError("could not decode json into hotel model")
                    }
                    
                    callback(.success(returnedHotel))
                    
                // Unhandled codes
                default:
                    let errors = BTAPITripError(errors: ["Something went wrong."])
                    callback(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPITripError(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
}






