//
//  NetworkingLayer+Hotels.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

extension NetworkStack {
    
    func create(a hotel: BTHotel, for trip: Trip, callback: @escaping (Result<BTHotel, UserfacingErrors>) -> ()) {
        apiService.request(.createHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedHotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(returnedHotel))
                    
                // Unhandled codes
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
    
    //TODO: test endpoint once api supports this endpoint
    func loadHotels(for trip: Trip, callback: @escaping (Result<[BTHotel], UserfacingErrors>) -> ()) {
        apiService.request(.loadHotels(for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let hotels = try? JSONDecoder().decode([BTHotel].self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(hotels))
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
    
    //TODO: test endpoint once api supports this endpoint
    func showHotel(for hotelId: Int, for trip: Trip, callback: @escaping (Result<BTHotel, UserfacingErrors>) -> ()) {
        apiService.request(.showHotel(forHotelId: hotelId, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let hotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(hotel))
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
    
    //TODO: test endpoint once api supports this endpoint
    func update(hotel: BTHotel, for trip: Trip, callback: @escaping (Result<BTHotel, UserfacingErrors>) -> ()) {
        apiService.request(.updateHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedHotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(updatedHotel))
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
    
    //TODO: test endpoint once api supports this endpoint
    func delete(hotel: BTHotel, for trip: Trip, callback: @escaping (Result<String, UserfacingErrors>) -> ()) {
        apiService.request(.deleteHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    callback(.success("\(hotel.title) was deleted"))
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
