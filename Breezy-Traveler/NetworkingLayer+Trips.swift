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
    
    func loadUserTrips(user: User, callback: @escaping (Result<[Trip], UserfacingErrors>) -> ()) {
        apiService.request(
            .loadTrips(user),
            completion: jsonResponse(decoder: .tripsDecoder, next: callback)
        )
    }
    
    func createTrip(trip: CreateTrip, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(.createTrip(trip)) { (result) in
            switch result {
            case .success(let response):
                
                switch response.statusCode {
                case 201:
                    guard let trip = try? JSONDecoder.trip(from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(trip))
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
    
    func showTrip(for id: String, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(.showTrip(forTripID: id)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let trip = try? JSONDecoder.trip(from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(trip))
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
    
    func update(trip: Trip, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(.updateTrip(trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedTrip = try? JSONDecoder.trip(from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(updatedTrip))
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
    
    
    func deleteTrip(trip: Trip, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(.deleteTrip(trip)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 204:
                    callback(.success(trip))
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
    
    func loadPublishedTrips(fetchAllTrips: Bool, callback: @escaping (Result<[Trip], UserfacingErrors>) -> ()) {
        apiService.request(.loadPublishedTrips(fetchAll: fetchAllTrips)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let trips = try? JSONDecoder.trips(from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(trips))
                case 401: //needs relogin
                    let user = LoginLayer.instance
                    user.needsLogin()
                    
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
    
    func loadPublishedTrips(for searchTerm: String, callback: @escaping (Result<[Trip], UserfacingErrors>) -> ()) {
        apiService.request(.searchPublishedTrips(searchTerm: searchTerm)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let trips = try? JSONDecoder.trips(from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(trips))
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
}

