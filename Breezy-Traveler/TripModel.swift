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
    let start_date: Date?
    let end_date: Date?
    
    // FIXME: Add these type later once we get this working
//    let hotels: [Hotel]
//    let sites: [Site]
    let is_public: Bool
    
    
}
