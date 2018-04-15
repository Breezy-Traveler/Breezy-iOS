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
    
    var place: String
    var startDate: Date?
    var endDate: Date?
    var hotels: [BTHotel]
    var sites: [BTSite]
    var coverImageUrl: URL?
    var isPublic: Bool
    //TODO: add notes to trips
    
    enum CodingKeys: String, CodingKey {
        case idValue = "id"
        case place
        case startDate = "start_date"
        case endDate = "end_date"
        case hotels
        case sites
        case coverImageUrl = "cover_image_url"
        case isPublic = "is_public"
    }
    
    init(
        id: Int? = nil,
        place: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        hotels: [BTHotel] = [],
        sites: [BTSite] = [],
        coverImageUrl: URL? = nil,
        isPublic: Bool) {
        
        self.idValue = id
        self.place = place
        self.startDate = startDate
        self.endDate = endDate
        self.hotels = hotels
        self.sites = sites
        self.coverImageUrl = coverImageUrl
        self.isPublic = isPublic
    }
}


