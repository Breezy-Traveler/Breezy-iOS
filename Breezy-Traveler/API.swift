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
    case registerUser
    case loginUser
    case createTrip(Trip)
    case loadTrips(BTUser)
}

// 2: Conforms and implements Target Type (Moya specific protocol)
extension BTAPIEndPoints: TargetType {
    
    // 3: Base URL leads to no end point
    var baseURL: URL { return URL(string: "https://breezy-traveler-api.herokuapp.com")! }
    
    // 4: get the path to the end point
    var path: String {
        switch self {
        case .registerUser:
                return "/register"
        case .loginUser:
            return "/login"
        case .createTrip, .loadTrips:
                return "/users/trips"
        }
    }
    
    // 5: HTTP Method
    var method: Moya.Method {
        switch self {
            
        // FIXME: Change login user to Patch request
        case .registerUser, .loginUser:
            return .post
        case .createTrip:
            return .post
        case .loadTrips:
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
        case .loadTrips:
            return .requestPlain
        case .createTrip(let trip):
            return .requestJSONEncodable(trip)
        default:
            return .requestPlain
        }
    }
    
    // 8: Include the header as the last bit of the request
    // Sample token for testing: "token": "50ccee39f6e8972364f454db5cb589da"
    
    var headers: [String : String]? {
        var defaultHeader = [String : String]()
        defaultHeader["Authorization"] = "Token token=50ccee39f6e8972364f454db5cb589da"
        switch self {
        case .loadTrips:
            // Uncomment when not testing
//            let token = user.token
            // FIXME: Change token to take in actual user token in future
            return defaultHeader
        default:
            return defaultHeader
        }
    }
}



