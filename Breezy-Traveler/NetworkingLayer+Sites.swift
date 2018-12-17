//
//  NetworkingLayer+Sites.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

extension NetworkStack {
    func create(a site: CreateSite, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(.createSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedSite = try? JSONDecoder().decode(Site.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(returnedSite))
                    
                // Unhandled codes
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
    
    func loadSites(for trip: Trip, callback: @escaping (Result<[Site], UserfacingErrors>) -> ()) {
        apiService.request(.loadSites(for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let sites = try? JSONDecoder().decode([Site].self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(sites))
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
    
    func showSite(for siteId: Int, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(.showSite(forSiteId: siteId, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let site = try? JSONDecoder().decode(Site.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(site))
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
    
    func update(site: Site, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(.updateSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedSite = try? JSONDecoder().decode(Site.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")
                        
                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    
                    callback(.success(updatedSite))
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
    
    func delete(site: Site, for trip: Trip, callback: @escaping (Result<String, UserfacingErrors>) -> ()) {
        apiService.request(.deleteSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 202:
                    callback(.success("\(site.name) was deleted"))
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
