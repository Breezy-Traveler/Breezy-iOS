//
//  BTSite.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct BTSite: Codable {
    let idValue: Int?
    
    /** A helper var to return the unwrapped idValue of hotel */
    var id: Int {
        get {
            guard let id = self.idValue else {
                fatalError("site did not have an id")
            }
            
            return id
        }
    }
    var title: String
    var address: String?
    var visited: Bool
    var notes: String?
    var rating: Like?
    //
    enum Like: Int, Codable {
        // Zero is dislike, one is like
        case dislike = 0
        case like = 1
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case address
        case visited = "is_visited"
        case notes
        case rating = "ratings"
        case idValue = "id"
    }
}
