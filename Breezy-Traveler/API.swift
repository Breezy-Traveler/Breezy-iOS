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
    case uploadUserProfileImage(imageData: Data)
    case userProfileImage(User)

    // Trips
    case createTrip(CreateTrip)
    case loadTrips(User)
    case showTrip(forTripID: String)
    case updateTrip(Trip)
    case deleteTrip(Trip)

    // Published Trips
    case loadPublishedTrips(fetchAll: Bool)
    case searchPublishedTrips(searchTerm: String)

    // Hotels
    case createHotel(CreateHotel, for: Trip)
    case loadHotels(for: Trip)
    case showHotel(forHotelId: Int, for: Trip)
    case updateHotel(Hotel, for: Trip)
    case deleteHotel(Hotel, for: Trip)

    // Sites
    case createSite(CreateSite, for: Trip)
    case loadSites(for: Trip)
    case showSite(forSiteId: Int, for: Trip)
    case updateSite(Site, for: Trip)
    case deleteSite(Site, for: Trip)

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
    var baseURL: URL { return URL(string: InfoPlist.baseUrlString)! }

    // 4: get the path to the end point
    var path: String {
        switch self {

        // Users
        case .registerUser:
            return "/signup"

        case .loginUser:
            return "/login"
            
        case .uploadUserProfileImage:
            return "/userProfile"
            
        case .userProfileImage(let user):
            return "/userProfile/\(user.profileImage ?? "no-image")"

        // Trips
        case .createTrip, .loadTrips:
//            return "/users/trips"
            return "/trips"

        case .showTrip(forTripID: let id):
//            return "/users/trips/\(id)"
            return "/trips/\(id)"

        case .updateTrip(let trip):
            let id = trip.id

//            return "/users/trips/\(id)"
            return "/trips/\(id)"

        case .deleteTrip(let trip):
            let id = trip.id
            
//            return "/users/trips/\(id)"
            return "/trips/\(id)"

        // Published Trips
        case .loadPublishedTrips, .searchPublishedTrips:
            return "/publishedTrips"

        // Hotels
        case .createHotel(_, for: let trip):
            let id = trip.id
            return "/trips/\(id)/hotels"

        case .loadHotels(for: let trip):
            let id = trip.id
            return "/trips/\(id)/hotels"

        case .showHotel(forHotelId: let id, for: let trip):
            let tripId = trip.id, hotelId = id
            return "/trips/\(tripId)/hotels/\(hotelId)"

        case .updateHotel(let hotel, for: let trip), .deleteHotel(let hotel, for: let trip):
            let tripId = trip.id, hotelId = hotel.id
            return "/trips/\(tripId)/hotels/\(hotelId)"

        // Sites
        case .createSite(_, for: let trip):
            let id = trip.id
            return "/trips/\(id)/sites"

        case .loadSites(for: let trip):
            let id = trip.id
            return "/trips/\(id)/sites"

        case .showSite(forSiteId: let id, for: let trip):
            let tripId = trip.id, siteId = id
            return "/trips/\(tripId)/sites/\(siteId)"

        case .updateSite(let site, for: let trip), .deleteSite(let site, for: let trip):
            let tripId = trip.id, siteId = site.id
            return "/trips/\(tripId)/sites/\(siteId)"

        // Images
        case .loadTenImages:
            return "/image-search"
        }
    }

    // 5: HTTP Method
    var method: Moya.Method {
        switch self {
        // Users
        case .registerUser, .loginUser:
            return .post
        case .uploadUserProfileImage:
            return .post
        case .userProfileImage:
            return .get

        // Trips
        case .createTrip:
            return .post
        case .loadTrips, .showTrip:
            return .get
        case .updateTrip:
            return .put
        case .deleteTrip:
            return .delete

        // Published Trips
        case .loadPublishedTrips, .searchPublishedTrips:
            return .get

        // Hotels
        case .createHotel:
            return .post
        case .loadHotels, .showHotel:
            return .get
        case .updateHotel:
            return .put
        case .deleteHotel:
            return .delete

        // Sites
        case .createSite:
            return .post
        case .loadSites, .showSite:
            return .get
        case .updateSite:
            return .put
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
        case .uploadUserProfileImage(let imageData):
            let body: [String: Any] = [
                "payload": imageData,
                "type": "image/png"
            ]
            
            return .requestParameters(parameters: body, encoding: URLEncoding.default)
        case .userProfileImage:
            return .requestPlain

        // Trips
        case .createTrip(let trip):
            return .requestCustomJSONEncodable(trip, encoder: JSONEncoder.tripsEncoder)
        case .updateTrip(let trip):
            return .requestCustomJSONEncodable(trip, encoder: JSONEncoder.tripsEncoder)

        // Published Trips
        case .loadPublishedTrips(let fetchAll):
            let limit = fetchAll ? 0 : 10
            return .requestParameters(parameters: ["searchLimit": limit], encoding: URLEncoding.default)
        case .searchPublishedTrips(let searchTerm):
            return .requestParameters(parameters: ["searchTerm" : searchTerm], encoding: URLEncoding.default)

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
            return .requestParameters(parameters: ["phrase": searchTerm], encoding: URLEncoding.default)

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
            let token = UserPersistence.currentUser.token

            // Authorization
            defaultHeaders["Authorization"] = "Token \(token)"
        }
        return defaultHeaders
    }
}

extension TargetType {
    var endpoint: URL {
        return self.baseURL.appendingPathComponent(self.path)
    }
}

extension User {
    var profileUrl: URL {
        let request = BTAPIEndPoints.userProfileImage(self)
        
        return request.endpoint
    }
}
