//
//  TripModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/30/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct Trip: Codable {
    let place: String
    let startDate: Date?
    let endDate: Date?
    
    // FIXME: Add these type later once we get this working
//    let hotels: [Hotel]
//    let sites: [Site]
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case place
        case startDate = "start_date"
        case endDate = "end_date"
        case isPublic = "is_public"
    }
    
}
