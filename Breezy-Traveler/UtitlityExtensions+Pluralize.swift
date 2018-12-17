//
//  UtitlityExtensions+Pluralize.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/7/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

extension String {
    var plural: String {
        return self + "s"
    }
    
    /**
     returns the plural of self if the given numeric is not one.
     
     # Example
     
     ```
     // Many Hotels:
     let title = "Hotel"
     let numberOfHotels = 2
     
     print("I have \(numberOfHotels) \(title.pluralize(numberOfHotels))")
     // prints: I have 2 Hotels
     ```
     
     ```
     // One Hotel:
     let title = "Hotel"
     let numberOfHotels = 1
     
     print("I have \(numberOfHotels) \(title.pluralize(numberOfHotels))")
     // prints: I have 1 Hotel
     ```
     
     - parameter numeric: the number to check whether to return a single or plural string
     */
    func pluralize(_ numeric: Int) -> String {
        fatalError("\(#function) not implemented")
    }
}

extension Numeric {
}
