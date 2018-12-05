//
//  HotelsViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct HotelsViewModel {
    
    // MARK: - VARS
    
    private let networking = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func fetchHotels(for trip: Trip, completion: @escaping ([Hotel]) -> Void) {
        
        networking.loadHotels(for: trip) { (result) in
            switch result {
            case .success(let hotels):
                completion(hotels)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion([])
            }
        }
    }
    
    func createHotel(name: String, address: String, for trip: Trip, compeltion: @escaping (Bool) -> Void) {

        let hotel = CreateHotel.init(name: name, address: address)
        networking.create(a: hotel, for: trip) { (result) in
            switch result {
            case .success(let createdHotel):
                compeltion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                compeltion(false)
            }
        }
    }
}
