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
    func create(a site: BTSite, for trip: BTTrip, completion: @escaping (Result<BTSite, BTAPIErrors>) -> ()) {
        apiService.request(.createSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                    
                // Created
                case 201:
                    guard let returnedSite = try? JSONDecoder().decode(BTSite.self, from: response.data) else {
                        fatalError("could not decode json into site model")
                    }
                    
                    completion(.success(returnedSite))
                    
                // Unhandled codes
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
    
    func loadSites(for trip: BTTrip, completion: @escaping (Result<[BTSite], BTAPIErrors>) -> ()) {
        apiService.request(.loadSites(for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let sites = try? JSONDecoder().decode([BTSite].self, from: response.data) else {
                        fatalError("could not decode response.data into site models")
                    }
                    
                    completion(.success(sites))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
    
    func showSite(for siteId: Int, for trip: BTTrip, completion: @escaping (Result<BTSite, BTAPIErrors>) -> ()) {
        apiService.request(.showSite(forSiteId: siteId, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let site = try? JSONDecoder().decode(BTSite.self, from: response.data) else {
                        fatalError("could not decode response.data into site model")
                    }
                    
                    completion(.success(site))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
    
    func update(site: BTSite, for trip: BTTrip, completion: @escaping (Result<BTSite, BTAPIErrors>) -> ()) {
        apiService.request(.updateSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    guard let updatedSite = try? JSONDecoder().decode(BTSite.self, from: response.data) else {
                        fatalError("could not decode response.data to site model")
                    }
                    
                    completion(.success(updatedSite))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
    
    func delete(site: BTSite, for trip: BTTrip, completion: @escaping (Result<String, BTAPIErrors>) -> ()) {
        apiService.request(.deleteSite(site, for: trip)) { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 204:
                    completion(.success("\(site.title) was deleted"))
                default:
                    let serverErrors = (try! JSON(data: response.data).dictionaryObject) ?? ["error": "Server Error"]
                    let errors = BTAPIErrors(errors: ["Something went wrong.", serverErrors.description])
                    
                    completion(.failure(errors))
                }
            case .failure(let err):
                let errors = BTAPIErrors(errors: [err.localizedDescription])
                completion(.failure(errors))
            }
        }
    }
}
