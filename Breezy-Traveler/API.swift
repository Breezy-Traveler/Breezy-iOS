//
//  API.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/28/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import Moya

// 1: All the end points for HTTP request
enum BTAPIEndPoints {
    // Users
    case registerUser(UserRegister)
    case loginUser(UserLogin)
    
    // Trips
    case createTrip(BTTrip)
    case loadTrips(BTUser)
    case showTrip(forTripID: Int)
    case updateTrip(BTTrip)
    case deleteTrip(BTTrip)
    
    // Published Trips
    case loadPublishedTrips(fetchAll: Bool)
    
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
    
    // Images
    case loadTenImages(String)
    
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
    // "https://breezy-traveler-api.herokuapp.com"
    var baseURL: URL { return URL(string: "http://localhost:3000")! }
    
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
            
        case .showTrip(forTripID: let id):
            return "/users/trips/\(id)"
            
        case .updateTrip(let trip):
            let id = trip.id
            
            return "/users/trips/\(id)"
            
        case .deleteTrip(let trip):
            let id = trip.id
            return "/users/trips/\(id)"
            
        // Published Trips
        case .loadPublishedTrips:
            return "/published_trips"
            
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
            
        // Images
        case .loadTenImages:
            return "/image_search"
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
        case .loadTrips, .showTrip:
            return .get
        case .updateTrip:
            return .patch
        case .deleteTrip:
            return .delete
            
        // Published Trips
        case .loadPublishedTrips:
            return .get

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
            
        // Images
        case .loadTenImages:
            return .get
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
        case .loginUser(let loginUser):
            return .requestJSONEncodable(loginUser)
          
        // Trips
        case .createTrip(let trip):
            return .requestJSONEncodable(trip)
        case .updateTrip(let trip):
            return .requestJSONEncodable(trip)
            
        // Published Trips
        case .loadPublishedTrips(let fetchAllTrips):
            return .requestParameters(parameters: ["fetch_all" : fetchAllTrips], encoding: URLEncoding.default)
            
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
            
        // Images
        case .loadTenImages(let searchTerm):
            return .requestParameters(parameters: ["search_term": searchTerm], encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    // 8: Include the header as the last bit of the request
    // Sample token for testing: "token": "a0a5304ef3a7ec90deb874a1dd3e4812"
    
    var headers: [String : String]? {
        var defaultHeaders = [String : String]()
        let userPersistence = UserPersistence()
        
        // default header pairs
        if self.isRegisteringOrLoginging {
            
        } else {
            guard let token = userPersistence.getUserToken() else {
                fatalError("no user token")
            }
            
            // Authorization
            defaultHeaders["Authorization"] = "Token token=\(token)"
        }
        return defaultHeaders
    }
}



