//
//  TripModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/30/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct BTTrip: Codable {
    let idValue: Int?
    
    /** A helper var to return the unwrapped idValue of trip */
    var id: Int {
        get {
            guard let id = self.idValue else {
                fatalError("trip did not have an id")
            }
            
            return id
        }
    }
    
    let place: String
    let startDate: Date?
    let endDate: Date?
    let hotels: [BTHotel]
    let sites: [Site]
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case idValue = "id"
        case place
        case startDate = "start_date"
        case endDate = "end_date"
        case hotels
        case sites
        case isPublic = "is_public"
    }
    
    init(
        id: Int? = nil,
        place: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        hotels: [BTHotel] = [],
        sites: [Site] = [],
        isPublic: Bool) {
        
        self.idValue = id
        self.place = place
        self.startDate = startDate
        self.endDate = endDate
        self.hotels = hotels
        self.sites = sites
        self.isPublic = isPublic
    }
}

struct Site: Codable {
    let name: String
    let address: String?
    let visited: Bool
    let notes: String?
    let rating: Like?
    //
    enum Like: Int, Codable {
        // Zero is dislike, one is like
        case dislike = 0
        case like = 1
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case address
        case visited = "is_visited"
        case notes
        case rating = "ratings"
    }
}


