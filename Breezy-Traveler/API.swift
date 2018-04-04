//
//  API.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/28/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import Moya

// 1: All the end points for HTTP request
enum BTAPIEndPoints {
    // Users
    case registerUser(UserRegister)
    case loginUser
    
    // Trips
    case createTrip(BTTrip)
    case loadTrips(BTUser)
    case deleteTrip(BTTrip)
    
    // Hotels
    case createHotel(BTHotel, for: BTTrip)
    case loadHotels(for: BTTrip)
    case showHotel(forHotelId: Int, for: BTTrip)
    case updateHotel(BTHotel, for: BTTrip)
    case deleteHotel(BTHotel, for: BTTrip)
    
    // Sites
    case createSite(BTSite, for: BTTrip)
    case loadSites(for: BTTrip)
    case showSite(forSiteId: Int, for: BTTrip)
    case updateSite(BTSite, for: BTTrip)
    case deleteSite(BTSite, for: BTTrip)
    
    /** if the enum is registerUser or loginUser, return true. otherwise return false */
    var isRegisteringOrLoginging: Bool {
        switch self {
        case .registerUser, .loginUser:
            return true
        default:
            return false
        }
    }
}

// 2: Conforms and implements Target Type (Moya specific protocol)
extension BTAPIEndPoints: TargetType {
    
    // 3: Base URL leads to no end point
    var baseURL: URL { return URL(string: "https://breezy-traveler-api.herokuapp.com")! }
    
    // 4: get the path to the end point
    var path: String {
        switch self {
            
        // Users
        case .registerUser:
            return "/register"
        case .loginUser:
            return "/login"
            
        // Trips
        case .createTrip, .loadTrips:
            return "/users/trips"
        case .deleteTrip(let trip):
            let id = trip.id
            
            return "/users/trips/\(id)"
            
        // Hotels
        case .createHotel(_, for: let trip):
            let id = trip.id
            
            return "/users/trips/\(id)/hotels"
        case .loadHotels(for: let trip):
            let id = trip.id
            
            return "/users/trips/\(id)/hotels"
        case .showHotel(forHotelId: let id, for: let trip):
            let tripId = trip.id, hotelId = id
            
            return "/users/trips/\(tripId)/hotels/\(hotelId)"
        case .updateHotel(let hotel, for: let trip), .deleteHotel(let hotel, for: let trip):
            let tripId = trip.id, hotelId = hotel.id
            
            return "/users/trips/\(tripId)/hotels/\(hotelId)"
            
        // Sites
        case .createSite(_, for: let trip):
            let id = trip.id
            
            return "/users/trips/\(id)/sites"
        case .loadSites(for: let trip):
            let id = trip.id
            
            return "/users/trips/\(id)/sites"
        case .showSite(forSiteId: let id, for: let trip):
            let tripId = trip.id, siteId = id
            
            return "/users/trips/\(tripId)/sites/\(siteId)"
        case .updateSite(let site, for: let trip), .deleteSite(let site, for: let trip):
            let tripId = trip.id, siteId = site.id
            
            return "/users/trips/\(tripId)/sites/\(siteId)"
        }
    }
    
    // 5: HTTP Method
    var method: Moya.Method {
        switch self {
            // Users
        case .registerUser, .loginUser:
            return .post

            // Trips
        case .createTrip:
            return .post
        case .loadTrips:
            return .get
        case .deleteTrip:
            return .delete

            // Hotels
        case .createHotel:
            return .post
        case .loadHotels, .showHotel:
            return .get
        case .updateHotel:
            return .patch
        case .deleteHotel:
            return .delete

            // Sites
        case .createSite:
            return .post
        case .loadSites, .showSite:
            return .get
        case .updateSite:
            return .patch
        case .deleteSite:
            return .delete
        }
    }
    
    // 6: Test the data in Swift
    // MARK: Todo later
    var sampleData: Data {
        return Data()
    }
    
    // 7: Body + params and any attachments
    var task: Task {
        switch self {
            
            // Users
        case .registerUser(let registerUser):
            return .requestJSONEncodable(registerUser)
          
            // Trips
        case .createTrip(let trip):
            return .requestJSONEncodable(trip)
            
            // Hotels
        case .createHotel(let hotel, for: _):
            return .requestJSONEncodable(hotel)
        case .updateHotel(let hotel, for: _):
            return .requestJSONEncodable(hotel)
            
        // Sites
        case .createSite(let site, for: _):
            return .requestJSONEncodable(site)
        case .updateSite(let site, for: _):
            return .requestJSONEncodable(site)
            
        default:
            return .requestPlain
        }
    }
    
    // 8: Include the header as the last bit of the request
    // Sample token for testing: "token": "a0a5304ef3a7ec90deb874a1dd3e4812"
    
    var headers: [String : String]? {
        var defaultHeaders = [String : String]()
        
        // default header pairs
        
        if self.isRegisteringOrLoginging {
            
        } else {
            
            // Authorization
            // FIXME: Change token to take in actual user token in future
            defaultHeaders["Authorization"] = "Token token=a0a5304ef3a7ec90deb874a1dd3e4812"
        }
        
        return defaultHeaders
    }
}



