//
//  UtilityExensions+UIAlertController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /**
     Adds a button with, or without an action closure with the given title
     
     - warning: the button's style is set to .default
     
     - returns: UIAlertController
     */
    public func addDismissButton(title: String = "Dismiss") -> UIAlertController {
        return self.addButton(title: title, with: { _ in })
    }
    
    /**
     Add a button with a title, style, and action.
     
     - warning: style and action defaults to .default and an empty closure body
     
     - returns: UIAlertController
     */
    public func addButton(title: String, style: UIAlertActionStyle = .default, with action: @escaping (UIAlertAction) -> () = {_ in}) -> UIAlertController {
        self.addAction(UIAlertAction(title: title, style: style, handler: action))
        
        return self
    }
    
    /**
     Add a button with the style set to .cancel.
     
     the default action is an empty closure body
     
     - returns: UIAlertController
     */
    public func addCancelButton(title: String = "Cancel", with action: @escaping (UIAlertAction) -> () = {_ in}) -> UIAlertController {
        return self.addButton(title: title, style: .cancel, with: action)
    }
    
    /**
     Adds a button with a cancel button after it
     
     - warning: cancel button's action is an empty closure
     
     - returns: UIAlertController
     */
    public func addConfirmationButton(title: String, style: UIAlertActionStyle = .default, with action: @escaping (UIAlertAction) -> ()) -> UIAlertController {
        return
            self.addButton(title: title, style: style, with: action)
                .addCancelButton()
    }
    
    /**
     For the given viewController, present(..) invokes viewController.present(..)
     
     - warning: viewController.present(.., animiated: true, ..doc)
     
     - returns: Discardable UIAlertController
     */
    @discardableResult
    public func present(in viewController: UIViewController, completion: (() -> ())? = nil) -> UIAlertController {
        viewController.present(self, animated: true, completion: completion)
        
        return self
    }
    
    var inputField: UITextField {
        return self.textFields!.first!
    }
}
