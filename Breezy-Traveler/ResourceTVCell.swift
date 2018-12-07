//
//  HotelTVCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class ResourceTVCell: UITableViewCell {

    // MARK: - VARS
    
    static let identifier = "resource cell"
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func configure(_ resource: Resource) {
        self.textLabel?.text = resource.name
        self.detailTextLabel?.text = resource.address.ifEmpty(use: "No address")
        self.detailTextLabel?.textColor = .lightGray
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}
