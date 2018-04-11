//
//  UtilityExtensions.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import UIKit

extension Collection where Index : Comparable {
    subscript(fromBack i: Int) -> Iterator.Element {
        let backBy = i
        return self[self.index(self.endIndex, offsetBy: backBy)]
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter nibName: the name of the nib to load from. use nil to use the
     class name as the nib name
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    static func loadFrom(nibName: String?) -> Self {
        if let nibName = nibName {
            return self.init(nibName: nibName, bundle: nil)
        } else {
            return self.init(nibName: String(describing: self), bundle: nil)
        }
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
