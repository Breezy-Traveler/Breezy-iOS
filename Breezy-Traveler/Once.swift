//
//  Once.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/13/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

fileprivate var history = [String: Job]()

struct Job {
    let expirationTime: Date?
    
    var isExpired: Bool {
        if let expiration = expirationTime {
            return expiration < Date()
        }
        
        return false
    }
    
    init(expirationTime: TimeInterval?) {
        if let offsetTime = expirationTime {
            self.expirationTime = Date(timeIntervalSinceNow: offsetTime)
        } else {
            self.expirationTime = nil
        }
    }
}

func once(every seconds: TimeInterval? = nil, _ key: String = #function, work: () -> Void) {
    let newJob = Job(expirationTime: seconds)
    if let prevJob = history[key] {
        if prevJob.isExpired {
            history[key] = newJob
            work()
        }
    } else {
        history[key] = newJob
        work()
    }
}

func reset(onceKey key: String = #function) {
    history.removeValue(forKey: key)
}
