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
     
     
     - parameter delegate: must assign a delegate to respond to error messages
     */
    init(delegate: TripDetailedViewModelDelegate) {
        self.delegate = delegate
    }
    
    private func pushTrip() {
        network.update(trip: self.trip) { [weak self] (result) in
            guard let unwrappedSelf = self else {
                return debugPrint("self was de-inititalized")
            }
            
            switch result {
            case .success:
                unwrappedSelf.delegate.viewModel(unwrappedSelf, didUpdate: unwrappedSelf.trip)
                
            case .failure(let err):
                debugPrint("failed to push trip: \(err.localizedDescription)")
                unwrappedSelf.delegate.viewModel(unwrappedSelf, didRecieve: err.errors)
            }
        }
    }
    
    private func pullTrip() {
        network.showTrip(for: self.trip.id) { [weak self] (result) in
            guard let unwrappedSelf = self else {
                return debugPrint("self was de-inititalized")
            }
            
            switch result {
            case .success(let returnedTrip):
                unwrappedSelf.delegate.viewModel(unwrappedSelf, didUpdate: returnedTrip)
            case .failure(let err):
                debugPrint("failed to pull trip: \(err.localizedDescription)")
                unwrappedSelf.delegate.viewModel(unwrappedSelf, didRecieve: err.errors)
            }
        }
    }
}

extension TripDetailedViewModel {
    
    func toggleIsPublished() {
        self.trip.isPublic.invert()
        self.pushTrip()
    }
    
    var tripPlace: String {
        return trip.place
    }
    
    func updatePlace(with newTitle: String) {
        trip.place = newTitle
        
        self.pushTrip()
    }
    
    func updateCoverImageUrl(with newCoverImageUrl: URL) {
        trip.coverImageUrl = newCoverImageUrl
        
        self.pushTrip()
    }
    
    func updateDates(start: Date?, end: Date?) {
        self.trip.startDate = start
        self.trip.endDate = end
        self.pushTrip()
    }
    
    var likesText: String {
        let nLikes = 999 //TODO: fetch the number of likes
        
        return "\(nLikes)"
    }
    
    var publishedText: String {
        if trip.isPublic {
            return "Shared"
        } else {
            return "Private"
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
