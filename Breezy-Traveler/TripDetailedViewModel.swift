//
//  TripDetailedViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation

protocol TripDetailedViewModelDelegate: class {
    func viewModel(_ model: TripDetailedViewModel, didUpdate trip: BTTrip)
    func viewModel(_ model: TripDetailedViewModel, didRecieve errors: [String])
}

// if changed to a class, refactor closures to avoid retain cycles
class TripDetailedViewModel {
    
    private var network = NetworkStack()
    
    var trip: BTTrip!
    
    unowned var delegate: TripDetailedViewModelDelegate
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter delegate: must assign a delegate to respond to error messages
     */
    init(delegate: TripDetailedViewModelDelegate) {
        self.delegate = delegate
    }
    
    private func pushTrip(completion: @escaping (Bool) -> ()) {
        network.update(trip: self.trip) { (result) in
            switch result {
            case .success:
                completion(true)
                
            case .failure(let err):
                self.delegate.viewModel(self, didRecieve: err.errors)
                completion(false)
            }
        }
    }
    
    private func pullTrip(completion: @escaping (BTTrip) -> ()) {
        network.showTrip(for: self.trip.id) { (result) in
            switch result {
            case .success(let returnedTrip):
                completion(returnedTrip)
            case .failure(let err):
                debugPrint("failed to pull trip")
                self.delegate.viewModel(self, didRecieve: err.errors)
            }
        }
    }
}

extension TripDetailedViewModel {
    
    func toggleIsPublished() {
        self.trip.isPublic.invert()
        self.pushTrip { (successful) in
            if successful {
                self.delegate.viewModel(self, didUpdate: self.trip)
            } else {
                debugPrint("failed to push trips")
            }
        }
    }
    
    var likesText: String {
        let nLikes = 999 //TODO: fetch the number of likes
        
        return "\(nLikes) Likes"
    }
    
    var publishedText: String {
        if trip.isPublic {
            return "Published!"
        } else {
            return "Ready to Publish?"
        }
    }
    
    var dateRangesSubtitle: String {
        if let startDate = trip.startDate {
            if let endDate = trip.endDate {
                let startDateText = String(date: startDate, dateStyle: .short)
                let endDateText = String(date: endDate, dateStyle: .short)
                
                return "\(startDateText) - \(endDateText)"
            } else {
                let startDateText = String(date: startDate, dateStyle: .medium)
                
                return "\(startDateText)"
            }
        } else {
            return "tap to setup a date"
        }
    }
    
    var hotelSubtitle: String {
        if trip.hotels.isEmpty {
            return "tap to add"
        } else {
            let firstHotel = trip.hotels.first!
            
            return firstHotel.title
        }
    }
    
    var siteSubtitle: String {
        if trip.sites.isEmpty {
            return "tap to add"
        } else {
            let firstSite = trip.sites.first!
            
            return firstSite.title
        }
    }
    
    var notesSubtitle: String {
        //TODO: add notes to trips
        return "tap to add"
    }
}
