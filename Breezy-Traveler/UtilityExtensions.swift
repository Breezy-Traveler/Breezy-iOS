//
//  UtilityExtensions.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/4/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static var defaultCoverImage: UIImage {
        return #imageLiteral(resourceName: "MountainsDefault")
    }
}

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

extension UIViewController {
    func setupNavigationBarAppearence() {
        // Set the navigation bar appearence for this viewController
        let nav = self.navigationController?.navigationBar
        
        // 2 Set the style for the bar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        // 3 Add our logo in text in the Nav Bar for this screen
        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        labelView.textColor = UIColor.white
        labelView.font = UIFont(name: "Absolute-Regular", size: 30)
        
        // 4 Set the text in the label
        let text = "Breezy Traveler"
        labelView.text = text
        
        // 5 Set the label on the navigation bar
        navigationItem.titleView = labelView
    }
}

// Extension on String to check for valid email
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    // Check that a password is between 6 to 20 chars long inclusive
    func isValidPassword() -> Bool {
        if self.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    /**
     checks if self is empty. If so, return the given default string.
     
     - parameter defaultString: return this if self is empty or nil
     
     - returns: either return self if not an empty string or return the given default value
     */
    func ifEmpty(use defaultString: String) -> String {
        if self.isEmpty {
            return defaultString
        } else {
            return self
        }
    }
    
    func joinIfNotEmptyOrNil(_ otherString: String?, by joiner: String) -> String {
        if let other = otherString, other.isNotEmpty {
            return self + joiner + other
        } else {
            return self
        }
    }
}

extension Optional where Wrapped == String {
    
    /**
     unwraps and checks if the string is empty. If so, return the given default string.
     
     This is similar to using the nil-colicent but also checks `.isEmpty`
     
     - parameter defaultString: return this if self is empty or nil
     
     - returns: either return self if not nil and not an empty string or return the given default value
     */
    func ifEmptyOrNil(use defaultString: String) -> String {
        if let unwrappedSelf = self, unwrappedSelf.isEmpty == false {
            return unwrappedSelf
        } else {
            return defaultString
        }
    }
}



