//
//  LoginLayer.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation

protocol LoginLayerDelegate: class {
    func userNeedsToLogin(_ loginLayer: LoginLayer)
}

class LoginLayer {
    
    static let instance = LoginLayer()
    
    weak var delegate: LoginLayerDelegate?
    
    func needsLogin() {
        delegate?.userNeedsToLogin(self)
    }
}
