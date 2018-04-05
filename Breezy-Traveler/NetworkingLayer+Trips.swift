//
//  NetworkingLayer+Trips.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

extension NetworkStack {
    struct BTAPIErrors: Error {
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
    
    func loadUserTrips(user: BTUser, callback: @escaping (Result<[BTTrip], BTAPIErrors>) -> ()) {
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
                    let errors = BTAPIErrors(errors: [String(describing: response)])
                    callback(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    func createTrip(trip: BTTrip, callback: @escaping (Result<BTTrip, BTAPIErrors>) -> ()) {
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
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
    
    func deleteTrip(trip: BTTrip, callback: @escaping (Result<BTTrip, BTAPIErrors>) -> ()) {
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
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                callback(.failure(errors))
            }
        }
    }
}

