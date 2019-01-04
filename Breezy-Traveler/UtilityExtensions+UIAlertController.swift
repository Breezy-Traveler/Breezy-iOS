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
     Add a textfield with the given text and placeholder text
     
     - warning: the newly added textfield invokes .setStyleToParagraph(..)
     
     - returns: UIAlertController
     */
    public func addTextField(defaultText: String? = nil, placeholderText: String? = nil) -> UIAlertController {
        self.addTextField(configurationHandler: { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: placeholderText, withInitalText: defaultText)
        })
        
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

extension UIAlertController {
    convenience init(editorTitle title: String, trip: Trip, name: String = "", address: String = "", action: @escaping (_ name: String, _ address: String) -> Void) {
        self.init(title: "New \(title)", message: "new \(title.lowercased()) for \(trip.place)", preferredStyle: .alert)
        _ = self.addTextField(defaultText: name, placeholderText: "\(title) Name")
        _ = self.addTextField(defaultText: address, placeholderText: "Address")
        _ = self.addConfirmationButton(title: "Add") { [weak self] _ in
            guard let unwrappedSelf = self else { return }
            
            guard
                let name = unwrappedSelf.textFields?[0].text,
                let address = unwrappedSelf.textFields?[1].text else {
                    return
            }
                
            action(name, address)
        }
    }
}

extension UIViewController {
    func presentAlert(error: String?, title: String = "", completion: (() -> Void)? = nil) {
        let alertTitle = title.ifEmpty(use: "Error")
        let alertMessage = error.ifEmptyOrNil(use: "something went wrong")
        
        UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            .addDismissButton()
            .present(in: self, completion: completion)
    }
    
    func presentAlert(error: UserfacingErrors, title: String = "", completion: (() -> Void)? = nil) {
        self.presentAlert(error: error.localizedDescription, title: title, completion: completion)
    }
}
