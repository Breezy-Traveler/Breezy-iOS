//
//  TripDetailedViewModel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation

struct TripDetailedViewModel {
    
    var trip: BTTrip!
    
}

extension TripDetailedViewModel {
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
