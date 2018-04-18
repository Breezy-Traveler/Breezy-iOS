//
//  TripModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/30/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct BTTrip {
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

extension BTTrip: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.place, forKey: .place)
        
        let formatter = ISO8601DateFormatter()
        
        if let startDate = self.startDate {
            let startIso = formatter.string(from: startDate)
            try container.encode(startIso, forKey: .startDate)
        }
        
        if let endDate = self.endDate {
            let endIso = formatter.string(from: endDate)
            try container.encode(endIso, forKey: .endDate)
        }
        
        try container.encode(self.hotels, forKey: .hotels)
        try container.encode(self.sites, forKey: .sites)
        try container.encode(self.coverImageUrl, forKey: .coverImageUrl)
        try container.encode(self.isPublic, forKey: .isPublic)
    }
}

extension BTTrip: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idValue = try container.decode(Int.self, forKey: .idValue)
        self.place = try container.decode(String.self, forKey: .place)
        
        
        
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        
        self.hotels = try container.decode([BTHotel].self, forKey: .hotels)
        self.sites = try container.decode([BTSite].self, forKey: .sites)
        self.coverImageUrl = try container.decode(URL.self, forKey: .coverImageUrl)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
    }
}

