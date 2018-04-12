//
//  ImagesCollectionViewCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return "imageCell"
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
