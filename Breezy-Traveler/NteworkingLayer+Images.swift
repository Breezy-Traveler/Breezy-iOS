//
//  NteworkingLayer+Images.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

extension NetworkStack {
    
    func fetchImages(searchTerm: String, callback: @escaping (Result<[URL], UserfacingErrors>) -> ()) {
        apiService.request(.loadTenImages(searchTerm)) { (result) in
            switch result {
                
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let urlArray = try? JSONDecoder().decode([URL].self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(urlArray))
                    
                default:
                    let errors = UserfacingErrors.serverError(message: response.data)
                    callback(.failure(errors))
                }
                
            case .failure(let err):
                let errors = UserfacingErrors.somethingWentWrong(message: err.localizedDescription)
                callback(.failure(errors))
            }
        }
    }
}
