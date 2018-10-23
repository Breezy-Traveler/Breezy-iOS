//
//  UtilityExtensions+UIImage.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 7/9/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    func scaled(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
