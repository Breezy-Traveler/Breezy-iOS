//
//  PublishedTripTableViewCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/8/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

//TODO: layout published trip cell
class PublishedTripTableViewCell: UITableViewCell {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func configure(_ trip: BTTrip) {
        
        // last published date
        //TODO: display last publishe date
        let nHotels = trip.hotels.count
        let nSites = trip.sites.count
        self.lastDatePublished.text = "Hotels: \(nHotels) Sites: \(nSites)"
        
        // cover image
//        if let coverImageUrl =  trip.coverImageUrl {
//            self.coverImage.kf.setImage(with: coverImageUrl)
//        } else {
//            self.coverImage.image = UIImage.defaultCoverImage
//        }
        
        // text
        self.placeName.text = trip.place
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var lastDatePublished: UILabel!
    
    // MARK: - LIFE CYCLE
    
    
}
