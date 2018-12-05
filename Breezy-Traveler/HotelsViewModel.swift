//
//  HotelsViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

class HotelsViewModel {
    
    // MARK: - VARS
    
    private(set) var hotels: [Hotel] = []
    
    private let networking = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func fetchHotels(for trip: Trip, completion: @escaping (Bool) -> Void) {
        
        networking.loadHotels(for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let hotels):
                unwrappedSelf.hotels = hotels
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func createHotel(name: String, address: String, for trip: Trip, compeltion: @escaping (Bool) -> Void) {
        
        let hotel = CreateHotel.init(name: name, address: address)
        networking.create(a: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let createdHotel):
                unwrappedSelf.hotels.insert(createdHotel, at: 0)
                compeltion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                compeltion(false)
            }
        }
    }
    
    func updateHotel(_ hotel: Hotel, for trip: Trip, compeltion: @escaping (Bool) -> Void) {
        
        networking.update(hotel: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let updatedHotel):
                if let indexToUpdate = unwrappedSelf.hotels.firstIndex(of: hotel) {
                    unwrappedSelf.hotels[indexToUpdate] = updatedHotel
                }
                
                compeltion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                compeltion(false)
            }
        }
    }
    
    func deleteHotel(_ hotel: Hotel, for trip: Trip, completion: @escaping (Bool) -> Void) {
        
        networking.delete(hotel: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let message):
                if let indexToRemove = unwrappedSelf.hotels.firstIndex(of: hotel) {
                    unwrappedSelf.hotels.remove(at: indexToRemove)
                }
                
                debugPrint(message)
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
}
