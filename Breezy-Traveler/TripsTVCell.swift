//
//  TripsTableVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripsTVCell: UITableViewCell, RegisterableCell {
    
    static var identifier: String = "tripsCell"
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func configure(_ trip: Trip) {
        
        // start date
        if let startDate = trip.startDate {
            self.subtitle.text = String(date: startDate, formatterMap: .Month_shorthand, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
        } else {
            self.subtitle.text = nil
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
    
    //TODO: use PublishedTripTableViewCell
    func configure(published trip: Trip) {
        
        // cover image
        if let coverImageUrl = trip.coverImageUrl {
            self.coverImage.kf.setImage(with: coverImageUrl)
        } else {
            self.coverImage.image = UIImage.defaultCoverImage
        }
        
        // text
        self.placeName.text = trip.place
        
        let nHotels = trip.hotels.count
        let nSites = trip.sites.count
        self.subtitle.text = "Hotels: \(nHotels) Sites: \(nSites)"
        self.isPublic.text = nil
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var isPublic: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    
    // MARK: - LIFE CYCLE
    

}
