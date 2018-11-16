//
//  UtilityExtensions+Codable.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 11/15/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

extension JSONEncoder {
    
    /**
     basic encoding for trips
     */
    static var tripsEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601)
        
        return encoder
    }
}

extension JSONDecoder {
    
    /**
     basic decoder for trips
     */
    static var tripsDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        
        return decoder
    }
    
    static func trip(from data: Data) throws -> Trip {
        let decoder = JSONDecoder.tripsDecoder
        
        return try decoder.decode(Trip.self, from: data)
    }
    
    static func trips(from data: Data) throws -> [Trip] {
        let decoder = JSONDecoder.tripsDecoder
        
        return try decoder.decode([Trip].self, from: data)
    }
}
