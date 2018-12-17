//
//  BTHotel.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct Hotel: Codable {
    let id: String
    var name: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
    }
}

extension Hotel: Equatable {
    
    static func == (lhs: Hotel, rhs: Hotel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CreateHotel: Encodable {
    let name: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CreateHotel.CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.address, forKey: .address)
    }
}
