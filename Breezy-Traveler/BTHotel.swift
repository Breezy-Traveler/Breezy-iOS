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
    
    #warning ("erick-remove (this was only used for mocking data)")
    init(name: String, address: String = "") {
        id = UUID.init().uuidString
        self.name = name
        self.address = address
    }
    
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
}

//struct BTHotel: Codable {
//    let idValue: Int?
//
//    /** A helper var to return the unwrapped idValue of hotel */
//    var id: Int {
//        get {
//            guard let id = self.idValue else {
//                fatalError("hotel did not have an id")
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
//
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
//
//    init(
//        id: Int? = nil,
//        title: String,
//        address: String? = nil,
//        visited: Bool,
//        notes: String? = nil,
//        rating: Like? = nil) {
//
//        self.idValue = id
//        self.title = title
//        self.address = address
//        self.visited = visited
//        self.notes = notes
//        self.rating = rating
//    }
//}
