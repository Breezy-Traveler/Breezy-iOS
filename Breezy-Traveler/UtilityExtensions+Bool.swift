//
//  UtilityExtensions+Bool.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

extension Bool {
    /**
     toggles the reciever
     */
    public mutating func invert() {
        if self == true {
            self = false
        } else {
            self = true
        }
    }
    
    /**
     returns a new toggled value of the reciever
     
     - returns: inverted value of the original bool
     */
    public var inverse: Bool {
        if self == true {
            return false
        } else {
            return true
        }
    }
}
