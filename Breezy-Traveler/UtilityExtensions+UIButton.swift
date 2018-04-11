//
//  UtilityExtensions+UIButton.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitleWithoutAnimation(_ title: String?, for state: UIControlState) {
        UIView.performWithoutAnimation {
            self.setTitle(title, for: state)
            self.layoutIfNeeded()
        }
    }
}
