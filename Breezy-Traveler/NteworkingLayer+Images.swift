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
        apiService.request(
            .loadTenImages(searchTerm),
            completion: jsonResponse(next: callback)
        )
    }
}
