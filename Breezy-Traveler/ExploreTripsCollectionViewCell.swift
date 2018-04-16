//
//  ExploreTripsCollectionViewCell.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit

class ExploreTripsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func configure(_ trip: BTTrip) {
        
        self.placeLabel.text = trip.place
//        self.placeLabel.minimumScaleFactor = 0.2
        
        if let coverImageUrl = trip.coverImageUrl {
            self.coverImage.kf.setImage(with: coverImageUrl)
        } else {
            self.coverImage.image = UIImage.defaultCoverImage
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    // MARK: - LIFE CYCLE
}
