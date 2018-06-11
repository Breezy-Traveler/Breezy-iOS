//
//  TripModel.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/30/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

struct BTTrip: Codable {
    let idValue: Int?
    
    /** A helper var to return the unwrapped idValue of trip */
    var id: Int {
        get {
            guard let id = self.idValue else {
                fatalError("trip did not have an id")
            }
            return id
        }
    }
    
    var place: String
    private var _startDate: String?
    var startDate: Date? {
        set {
            if let newDate = newValue {
                let formatter = ISO8601DateFormatter()
                self._startDate = formatter.string(from: newDate)
            } else {
                self._startDate = nil
            }
        }
        get {
            if let dateValue = self._startDate {
                let formatter = ISO8601DateFormatter()
                guard let date = formatter.date(from: dateValue) else {
                    assertionFailure("failed to convert date from iso86601")
                    
                    return nil
                }
                
                return date
            }
            
            return nil
        }
    }
    
    private var _endDate: String?
    var endDate: Date? {
        set {
            if let newDate = newValue {
                let formatter = ISO8601DateFormatter()
                self._endDate = formatter.string(from: newDate)
            } else {
                self._endDate = nil
            }
        }
        get {
            if let dateValue = self._endDate {
                let formatter = ISO8601DateFormatter()
                guard let date = formatter.date(from: dateValue) else {
                    assertionFailure("failed to convert date from iso86601")
                    
                    return nil
                }
                
                return date
            }
            
            return nil
        }
    }
    
    var hotels: [BTHotel]
    var sites: [BTSite]
    var coverImageUrl: URL?
    var isPublic: Bool
    var notes: String
    
    enum CodingKeys: String, CodingKey {
        case idValue = "id"
        case place
        case _startDate = "start_date"
        case _endDate = "end_date"
        case hotels
        case sites
        case coverImageUrl = "cover_image_url"
        case isPublic = "is_public"
        case notes
    }
    
    init(
        id: Int? = nil,
        place: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        hotels: [BTHotel] = [],
        sites: [BTSite] = [],
        coverImageUrl: URL? = nil,
        notes: String = "",
        isPublic: Bool) {
        
        //properties
        self.idValue = id
        self.place = place
        self.hotels = hotels
        self.sites = sites
        self.coverImageUrl = coverImageUrl
        self.isPublic = isPublic
        self.notes = notes
        
        //computed vars
        self.startDate = startDate
        self.endDate = endDate
    }
}


