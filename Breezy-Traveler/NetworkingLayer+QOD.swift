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

extension NetworkStack {
    
    func getQuoteOfTheDay(callback: @escaping (Quote) -> ()) {
        qodApiService.request(.getQuote) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let json = try? JSON(data: response.data) else {
                        fatalError("No json")
                        
                    }
                    
                    let jsonContents = json["contents"]
                    let jsonQuote = jsonContents["quotes"][0]
                    guard let jsonQuoteData = try? jsonQuote.rawData() else {
                        fatalError("no json data")
                    }
                    
                    guard let quote = try? JSONDecoder().decode(Quote.self, from: jsonQuoteData) else {
                        fatalError("No quote")
                    }
                    //                    print(quote)
                    callback(quote)
                default:
                    return assertionFailure("\(response.statusCode)")
                }
                
            case .failure(let err):
                break
                //TODO: invoke callback(.failure(errors))
                //                let errors = BTAPITripError(errors: [err.localizedDescription])
                //                callback(.failure(errors))
            }
        }
    }
}
