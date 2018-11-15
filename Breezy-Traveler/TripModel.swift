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
    var hotels: [BTHotel]
    var sites: [BTSite]
    var coverImageUrl: URL?
    var isPublic: Bool
    var notes: String?
    
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
}

/**
 used only for posting a new trip
 */
struct CreateTrip: Encodable {
    let place: String
    let startDate: Date? = nil
    let endDate: Date? = nil
    let hotels: [BTHotel] = []
    let sites: [BTSite] = []
    let coverImageUrl: URL? = nil
    let isPublic: Bool = false
    let notes: String? = nil
    
    init(place: String) {
        self.place = place
    }
}
