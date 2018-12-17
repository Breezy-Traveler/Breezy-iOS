//
//  BTSite.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct Site: Codable {
    let id: String
    var name: String
    var address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
    }
}

extension Site: Equatable {
    
    static func == (lhs: Site, rhs: Site) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CreateSite: Encodable {
    let name: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CreateSite.CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.address, forKey: .address)
    }
}

//struct BTSite: Codable {
//    let idValue: Int?
//
//    /** A helper var to return the unwrapped idValue of hotel */
//    var id: Int {
//        get {
//            guard let id = self.idValue else {
//                fatalError("site did not have an id")
//            }
//
//            return id
//        }
//    }
//    var title: String
//    var address: String?
//    var visited: Bool
//    var notes: String?
//    var rating: Like?
//    //
//    enum Like: Int, Codable {
//        // Zero is dislike, one is like
//        case dislike = 0
//        case like = 1
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case address
//        case visited = "is_visited"
//        case notes
//        case rating = "ratings"
//        case idValue = "id"
//    }
//}
