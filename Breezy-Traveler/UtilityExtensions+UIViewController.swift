//
//  UtilityExtensions+UIViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 5/2/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit.UIViewController

protocol Interfacable where Self: UIViewController {
    static func instantiateFromXib() -> Self
}

extension Interfacable {
    static func instantiateFromXib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}

extension UIViewController {
  var screenSize: CGSize {
    return UIScreen.main.bounds.size
  }
}
