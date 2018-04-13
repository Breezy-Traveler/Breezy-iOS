//
//  NetworkingLayer+QOD.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


// 1: All the end points for HTTP request
enum QODAPIEndPoint {
    case getQuote
}

// 2: Conforms and implements Target Type (Moya specific protocol)
extension QODAPIEndPoint: TargetType {
    
    // 3: Base URL leads to no end point
    var baseURL: URL { return URL(string: "https://breezy-traveler-api.herokuapp.com/quote_of_the_day")! }
    
    // 4: Since we have the full route in the baseURL,
    // no need to concatenate the path
    var path: String {
        switch self {
        case .getQuote:
            return ""
        }
    }
    
    // 5: HTTP Method, only need a simple get request
    var method: Moya.Method {
        switch self {
        case .getQuote:
            return .get
        }
    }
    
    // 6: Test the data in Swift
    var sampleData: Data {
        return Data()
    }
    
    // 7: Body + params and any attachments
    var task: Task {
        switch self {
        case .getQuote:
            return .requestPlain
        }
    }
    
    // 8: Include the header as the last bit of the request
    // Sample token for testing: "token": "a0a5304ef3a7ec90deb874a1dd3e4812"
    
    var headers: [String : String]? {
        var defaultHeaders = [String : String]()
        let userPersistence = UserPersistence()
        
      
            guard let token = userPersistence.getUserToken() else {
                fatalError("no user token")
            }
            
            // Authorization
            defaultHeaders["Authorization"] = "Token token=\(token)"
        
        return defaultHeaders
    }
}

extension NetworkStack {
    
    func getQuoteOfTheDay(callback: @escaping (Quote) -> ()) {
        qodApiService.request(.getQuote) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let json = try? JSON(data: response.data) else { fatalError("No json") }
                    let jsonQuote = json["quote"]
                    
                    guard let jsonQuoteData = try? jsonQuote.rawData() else { fatalError("no json data") }
                    guard let quote = try? JSONDecoder().decode(Quote.self, from: jsonQuoteData) else { fatalError("No quote") }
                    callback(quote)
                
                default:
                    return assertionFailure("\(response.statusCode)")
                }
                
            case .failure(let err):
                print("Error: \(err)")
                break
            }
        }
    }
}
