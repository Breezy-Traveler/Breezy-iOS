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
        apiService.request(
            .createHotel(hotel, for: trip),
            completion: jsonResponse(expectedSuccessCode: 201, next: callback)
        )
    }
    
    func loadHotels(for trip: Trip, callback: @escaping (Result<[Hotel], UserfacingErrors>) -> ()) {
        apiService.request(
            .loadHotels(for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func showHotel(for hotelId: Int, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(
            .showHotel(forHotelId: hotelId, for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func update(hotel: Hotel, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(
            .updateHotel(hotel, for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func delete(hotel: Hotel, for trip: Trip, callback: @escaping (Result<Hotel, UserfacingErrors>) -> ()) {
        apiService.request(
            .deleteHotel(hotel, for: trip),
            completion: jsonResponse(expectedSuccessCode: 202, successfulResponse: { (response) in
                callback(.success(hotel))
            }, failureResponse: { (userError) in
                callback(.failure(userError))
            })
        )
    }
}
