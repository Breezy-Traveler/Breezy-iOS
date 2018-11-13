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
    
    func configure(_ trip: Trip) {
        
        self.placeLabel.text = trip.place
        self.placeLabel.layer.shadowColor = UIColor.black.cgColor
        self.placeLabel.layer.shadowRadius = 1.25
        self.placeLabel.layer.shadowOpacity = 1.0
        self.placeLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
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
