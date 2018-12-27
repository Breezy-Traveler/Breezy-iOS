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
        apiService.request(
            .createTrip(trip),
            completion: jsonResponse(expectedSuccessCode: 201, decoder: .tripsDecoder, next: callback)
        )
    }
    
    func showTrip(for id: String, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(
            .showTrip(forTripID: id),
            completion: jsonResponse(decoder: .tripsDecoder, next: callback)
        )
    }
    
    func update(trip: Trip, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(
            .updateTrip(trip),
            completion: jsonResponse(decoder: .tripsDecoder, next: callback)
        )
    }
    
    func deleteTrip(trip: Trip, callback: @escaping (Result<Trip, UserfacingErrors>) -> ()) {
        apiService.request(
            .deleteTrip(trip),
            completion: jsonResponse(expectedSuccessCode: 204, successfulResponse: { (response) in
                callback(.success(trip))
            }, failureResponse: { (userError) in
                callback(.failure(userError))
            })
        )
    }
    
    func loadPublishedTrips(fetchAllTrips: Bool, callback: @escaping (Result<[Trip], UserfacingErrors>) -> ()) {
        apiService.request(
            .loadPublishedTrips(fetchAll: fetchAllTrips),
            completion: jsonResponse(decoder: .tripsDecoder, next: callback)
        )
    }
    
    func loadPublishedTrips(for searchTerm: String, callback: @escaping (Result<[Trip], UserfacingErrors>) -> ()) {
        apiService.request(
            .searchPublishedTrips(searchTerm: searchTerm),
            completion: jsonResponse(decoder: .tripsDecoder, next: callback)
        )
    }
}

