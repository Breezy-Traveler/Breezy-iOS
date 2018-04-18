//
//  TripsTableVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripsTVCell: UITableViewCell {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func configure(_ trip: BTTrip) {
        
        // start date
        if let startDate = trip.startDate {
            self.date.text = String(date: startDate, formatterMap: .Month_shorthand, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
        } else {
            self.date.text = nil
        }
        
        // cover image
        if let coverImageUrl =  trip.coverImageUrl {
            self.coverImage.kf.setImage(with: coverImageUrl)
        } else {
            self.coverImage.image = UIImage.defaultCoverImage
        }
        
        // text
        self.placeName.text = trip.place
        self.isPublic.text = trip.isPublic ? "Shared" : "Private"
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var isPublic: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    // MARK: - LIFE CYCLE
    

}
