//
//  QuoteModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

//struct Contents {
//    let quotes: [Quotes]
//}

struct Quote: Decodable {
    var quote: String?
    var author: String?
}
