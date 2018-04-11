//
//  NteworkingLayer+Images.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension NetworkStack {
    
    func fetchImages(searchTerm: String, callback: @escaping ([URL]) -> ()) {
        apiService.request(.loadTenImages(searchTerm)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let imagesArray = try? JSON(data: response.data),
                        let urlData = try? imagesArray["images"].rawData(),
                        let urlArray = try? JSONDecoder().decode([URL].self, from: urlData) else {
                        fatalError("not JSON decodable")
                    }
                    callback(urlArray)
                    
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
