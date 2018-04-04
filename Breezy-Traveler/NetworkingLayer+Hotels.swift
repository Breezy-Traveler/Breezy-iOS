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
    func create(a hotel: BTHotel, for trip: BTTrip, completion: @escaping (Result<BTHotel, BTAPIErrors>) -> ()) {
        apiService.request(.createHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedHotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        fatalError("could not decode json into hotel model")
                    }
                    
                    completion(.success(returnedHotel))
                    
                // Unhandled codes
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
    
    func loadHotels(for trip: BTTrip, completion: @escaping (Result<[BTHotel], BTAPIErrors>) -> ()) {
        apiService.request(.loadHotels(for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let hotels = try? JSONDecoder().decode([BTHotel].self, from: response.data) else {
                        fatalError("could not decode response.data into BTHotel models")
                    }
                    
                    completion(.success(hotels))
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
    
//    case showHotel(BTHotel, for: BTTrip)
    
    func update(hotel: BTHotel, for trip: BTTrip, completion: @escaping (Result<BTHotel, BTAPIErrors>) -> ()) {
        apiService.request(.updateHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedHotel = try? JSONDecoder().decode(BTHotel.self, from: response.data) else {
                        fatalError("could not decode response.data to hotel model")
                    }
                    
                    completion(.success(updatedHotel))
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
    
    func delete(hotel: BTHotel, for trip: BTTrip, completion: @escaping (Result<String, BTAPIErrors>) -> ()) {
        apiService.request(.deleteHotel(hotel, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    completion(.success("\(hotel.title) was deleted"))
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

}
