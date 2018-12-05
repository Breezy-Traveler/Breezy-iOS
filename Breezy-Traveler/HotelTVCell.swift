//
//  HotelTVCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class HotelTVCell: UITableViewCell {

    // MARK: - VARS
    
    static let identifier = "hotel cell"
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func configure(_ hotel: Hotel) {
        self.textLabel?.text = hotel.name
        self.detailTextLabel?.text = hotel.address.ifEmpty(use: "No address")
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}
