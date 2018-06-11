//
//  NetworkingLayer.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/29/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON


struct NetworkStack {

    private(set) var apiService = MoyaProvider<BTAPIEndPoints>()
    private(set) var qodApiService = MoyaProvider<QODAPIEndPoint>()

    // MARK: - User Login
    func register(a user: UserRegister, callback: @escaping (Result<BTUser, UserfacingErrors>) -> ()) {
        /// handles the response data after the networkService has fired and come back with a result
        apiService.request(.registerUser(user)) { (result) in

            switch result {
            case .success(let response):

                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")

                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }

                    callback(.success(user))
                case 422:
                    let errors = UserfacingErrors(userData: response.data)
                    callback(.failure(errors))

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

    func login(a user: UserLogin, callback: @escaping (Result<BTUser, UserfacingErrors>) -> ()) {
        apiService.request(.loginUser(user)) { (result) in
            switch result {
            case .success(let response):

                // FIXME: handle 401 (invalid credentials)
                switch response.statusCode {
                case 201:
                    guard let user = try? JSONDecoder().decode(BTUser.self, from: response.data) else {
                        assertionFailure("JSON data not decodable")

                        let errors = UserfacingErrors.somethingWentWrong()
                        return callback(.failure(errors))
                    }
                    callback(.success(user))

                case 401:
                    let errors = UserfacingErrors.invalidCredentials()
                    callback(.failure(errors))

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
    
    func update(a user: BTUser, callback: @escaping (Result<BTUser, UserfacingErrors>) -> ()) {
        apiService.request(.updateUser(user)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let statusCode = try response.filterSuccessfulStatusCodes()
                    print(statusCode)
                    let user = try JSONDecoder().decode(BTUser.self, from: response.data)
                    callback(.success(user))
                } catch {

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
