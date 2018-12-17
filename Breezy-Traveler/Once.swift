//
//  Once.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/13/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

var history = Set<String>()

func once(_ key: String = #function, work: () -> Void) {
    if history.contains(key) == false {
        history.insert(key)
        work()
    }
}

func reset(onceKey key: String = #function) {
    history.remove(key)
}
