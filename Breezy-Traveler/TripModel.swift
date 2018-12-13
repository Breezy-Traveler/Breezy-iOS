//
//  TripModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/30/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

/**
 used for reading, updating and deleting a trip
 */
struct Trip: Codable {
    
    var id: String
    var place: String
    var startDate: Date?
    var endDate: Date?
    var hotels: [Hotel]
    var sites: [BTSite]
    var coverImageUrl: URL?
    var isPublic: Bool
    var notes: String
    
    #warning ("erick-remove mocked data after backend supports endpoint (GET published-trips)")
    init(place: String) {
        self.id = UUID().uuidString
        self.place = place
        self.hotels = []
        self.sites = []
        self.isPublic = true
        self.notes = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case place
        case startDate
        case endDate
        case hotels
        case sites
        case coverImageUrl
        case isPublic
        case notes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.place, forKey: .place)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.hotels, forKey: .hotels)
        try container.encode(self.sites, forKey: .sites)
        try container.encode(self.coverImageUrl, forKey: .coverImageUrl)
        try container.encode(self.isPublic, forKey: .isPublic)
        try container.encode(self.notes, forKey: .notes)
    }
}

/**
 used only for posting a new trip
 */
struct CreateTrip: Encodable {
    let place: String
    let startDate: Date? = nil
    let endDate: Date? = nil
    let hotels: [Hotel] = []
    let sites: [BTSite] = []
    let coverImageUrl: URL? = nil
    let isPublic: Bool = false
    let notes: String = ""
    
    init(place: String) {
        self.place = place
    }
    
    enum CodingKeys: String, CodingKey {
        case place
        case startDate
        case endDate
        case hotels
        case sites
        case coverImageUrl
        case isPublic
        case notes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.place, forKey: .place)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.hotels, forKey: .hotels)
        try container.encode(self.sites, forKey: .sites)
        try container.encode(self.coverImageUrl, forKey: .coverImageUrl)
        try container.encode(self.isPublic, forKey: .isPublic)
        try container.encode(self.notes, forKey: .notes)
    }
}
