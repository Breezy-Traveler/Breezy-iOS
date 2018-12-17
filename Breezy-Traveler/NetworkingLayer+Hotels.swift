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
    
    func create(a hotel: CreateHotel, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(.createHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedHotel = try? JSONDecoder().decode(Hotel.self, from: response.data) else {
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
    
    func loadHotels(for trip: Trip, callback: @escaping (Result<[Hotel], UserfacingErrors>) -> ()) {
        apiService.request(.loadHotels(for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let hotels = try? JSONDecoder().decode([Hotel].self, from: response.data) else {
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
    
    func showHotel(for hotelId: Int, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(.showHotel(forHotelId: hotelId, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let hotel = try? JSONDecoder().decode(Hotel.self, from: response.data) else {
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
    
    func update(hotel: Hotel, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(.updateHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedHotel = try? JSONDecoder().decode(Hotel.self, from: response.data) else {
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
    
    func delete(hotel: Hotel, for trip: Trip, callback: @escaping (Result<String, UserfacingErrors>) -> ()) {
        apiService.request(.deleteHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 202:
                    callback(.success("\(hotel.name) was deleted"))
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
