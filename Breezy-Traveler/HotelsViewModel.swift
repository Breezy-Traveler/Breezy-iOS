//
//  HotelsViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

class HotelsViewModel: ResourceViewModel {
    
    var resource: [Resource] = []
    
    let resourceName: String = "Hotel"
    
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
            case .success(let message):
                if let indexToRemove = unwrappedSelf.resource.firstIndex(where: { $0.id == resource.id }) {
                    unwrappedSelf.resource.remove(at: indexToRemove)
                }
                
                debugPrint(message)
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    
    // MARK: - VARS
    
//    private(set) var hotels: [Hotel] = []
    
    private let networking = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func fetchHotels(for trip: Trip, completion: @escaping (Bool) -> Void) {
    }
    
    func createHotel(name: String, address: String, for trip: Trip, compeltion: @escaping (Bool) -> Void) {
    }
    
    func updateHotel(_ hotel: Hotel, for trip: Trip, compeltion: @escaping (Bool) -> Void) {
    }
    
    func deleteHotel(_ hotel: Hotel, for trip: Trip, completion: @escaping (Bool) -> Void) {
    }
}

extension Hotel: Resource {
    
}
