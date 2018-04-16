//
//  UtilityExtension+UITextField.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/10/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

extension UITextField {
    
    /**
     set the textfield's auto correction type to default and auto capitalization
     type to sentences and update the text and placeholder text
     */
    open func setStyleToParagraph(withPlaceholderText placeholder: String? = "", withInitalText text: String? = "") {
        self.autocorrectionType = .default
        self.autocapitalizationType = .sentences
        self.text = text
        self.placeholder = placeholder
        
    }
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter <#bar#>: <#Consectetur adipisicing elit.#>
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    func isEmpty() -> Bool {
        return self.text != "" && self.text != nil
    }
    
}
