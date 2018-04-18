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
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)
                        
                        let formatter = DateFormatter()
                        formatter.calendar = Calendar(identifier: .iso8601)
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        formatter.timeZone = TimeZone(secondsFromGMT: 0)
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date()
                    })
                    
                    guard let trips = try? decoder.decode([BTTrip].self, from: response.data) else {
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
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    guard let trip = try? decoder.decode(BTTrip.self, from: response.data) else {
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
    
    func showTrip(for id: Int, completion: @escaping (Result<BTTrip, BTAPIErrors>) -> ()) {
        apiService.request(.showTrip(forTripID: id)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    guard let trip = try? decoder.decode(BTTrip.self, from: response.data) else {
                        fatalError("could not decode response.data into trip model")
                    }
                    
                    completion(.success(trip))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
    
    func update(trip: BTTrip, completion: @escaping (Result<BTTrip, BTAPIErrors>) -> ()) {
        apiService.request(.updateTrip(trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    guard let updatedTrip = try? decoder.decode(BTTrip.self, from: response.data) else {
                        fatalError("could not decode response.data to trip model")
                    }
                    
                    completion(.success(updatedTrip))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
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
    
    func loadPublishedTrips(fetchAllTrips: Bool, completion: @escaping (Result<[BTTrip], BTAPIErrors>) -> ()) {
        apiService.request(.loadPublishedTrips(fetchAll: fetchAllTrips)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    guard let trips = try? decoder.decode([BTTrip].self, from: response.data) else {
                        fatalError("could not convert into trips models")
                    }
                    
                    completion(.success(trips))
                default:
                    let errors = BTAPIErrors(errors: ["Something went wrong: \(response.statusCode)"])
                    completion(.failure(errors))
                }
                
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
}

