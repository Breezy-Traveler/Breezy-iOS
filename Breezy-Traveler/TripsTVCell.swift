//
//  TripsTableVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripsTVCell: UITableViewCell {
    
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var isPublic: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
