//
//  HotelsViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

class HotelsViewModel: ResourceViewModel {
    
    // MARK: - VARS
    
    var trip: Trip
    
    var resource: [Resource] {
        set {
            guard let hotels = newValue as? [Hotel] else {
                fatalError("new value is not an array of hotels")
            }
            
            trip.hotels = hotels
        }
        get {
            return trip.hotels
        }
    }
    
    let resourceName: String = "Hotel"
    
    private let networking = NetworkStack()
    
    required init(trip: Trip) {
        self.trip = trip
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func loadResource(for trip: Trip) {
//        resource = trip.hotels
    }
    
    func fetchResource(for trip: Trip, completion: @escaping (Bool) -> Void) {
        
        networking.loadHotels(for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let hotels):
                unwrappedSelf.resource = hotels
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func createResource(name: String, address: String, for trip: Trip, completion: @escaping (Bool) -> Void) {
        
        let hotel = CreateHotel(name: name, address: address)
        networking.create(a: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let createdHotel):
                unwrappedSelf.resource.insert(createdHotel, at: 0)
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func updateResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void) {
        guard let hotel = resource as? Hotel else {
            fatalError("resource given failed to downcast to a Hotel")
        }
        
        networking.update(hotel: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let updatedHotel):
                if let indexToUpdate = unwrappedSelf.resource.firstIndex(where: { $0.id == resource.id }) {
                    unwrappedSelf.resource[indexToUpdate] = updatedHotel
                }
                
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func deleteResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void) {
        guard let hotel = resource as? Hotel else {
            fatalError("resource given failed to downcast to a Hotel")
        }
        
        networking.delete(hotel: hotel, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success:
                if let indexToRemove = unwrappedSelf.resource.firstIndex(where: { $0.id == resource.id }) {
                    unwrappedSelf.resource.remove(at: indexToRemove)
                }
                
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
}

extension Hotel: Resource {
    
}
