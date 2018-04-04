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
