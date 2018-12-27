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
        apiService.request(
            .createSite(site, for: trip),
            completion: jsonResponse(expectedSuccessCode: 201, next: callback)
        )
    }
    
    func loadSites(for trip: Trip, callback: @escaping (Result<[Site], UserfacingErrors>) -> ()) {
        apiService.request(
            .loadSites(for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func showSite(for siteId: Int, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(
            .showSite(forSiteId: siteId, for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func update(site: Site, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(
            .updateSite(site, for: trip),
            completion: jsonResponse(next: callback)
        )
    }
    
    func delete(site: Site, for trip: Trip, callback: @escaping (Result<Site, UserfacingErrors>) -> ()) {
        apiService.request(
            .deleteSite(site, for: trip),
            completion: jsonResponse(expectedSuccessCode: 202, successfulResponse: { (response) in
                callback(.success(site))
            }, failureResponse: { (userError) in
                callback(.failure(userError))
            })
        )
    }
}
