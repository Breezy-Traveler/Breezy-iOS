//
//  UtilityExtensions+Interfacable.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/13/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

protocol InstantiatableFromXib {
    static func instantiateFromXib() -> Self
}

extension InstantiatableFromXib where Self: UIViewController {
    static func instantiateFromXib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}

protocol RegisterableCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension RegisterableCell {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension UITableView {
    func register<T: RegisterableCell>(_ type: T.Type) {
        let identifier = type.identifier
        let nib = type.nib
        
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}
