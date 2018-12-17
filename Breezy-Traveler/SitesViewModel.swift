//
//  SitesViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/7/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

class SitesViewModel: ResourceViewModel {
    
    // MARK: - VARS
    
    var resource: [Resource] = [Site]()
    
    let resourceName: String = "Site"
    
    private let networking = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func fetchResource(for trip: Trip, completion: @escaping (Bool) -> Void) {
        
        networking.loadSites(for: trip) { [weak self] (result) in
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
        
        let site = CreateSite(name: name, address: address)
        networking.create(a: site, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let createdSite):
                unwrappedSelf.resource.insert(createdSite, at: 0)
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func updateResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void) {
        guard let site = resource as? Site else {
            fatalError("resource given failed to downcast to a Site")
        }
        
        networking.update(site: site, for: trip) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let updatedSite):
                if let indexToUpdate = unwrappedSelf.resource.firstIndex(where: { $0.id == resource.id }) {
                    unwrappedSelf.resource[indexToUpdate] = updatedSite
                }
                
                completion(true)
            case .failure(let err):
                assertionFailure(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func deleteResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void) {
        guard let site = resource as? Site else {
            fatalError("resource given failed to downcast to a Site")
        }
        
        networking.delete(site: site, for: trip) { [weak self] (result) in
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
}

extension Site: Resource {
    
}
