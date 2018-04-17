//
//  UICoverImageView.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Kingfisher


@objc protocol UICoverImageViewDelegate: class {
    @objc optional func coverImage(view: UICoverImageView, leftButtonIconDidPress button: UIButton)
    @objc optional func coverImage(view: UICoverImageView, coverImageDidPressWith gesture: UITapGestureRecognizer)
}

class UICoverImageView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var delegate: UICoverImageViewDelegate?
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load the nib
        self.view = Bundle.main.loadNibNamed("UICoverImageView", owner: self, options: nil)?.first! as! UIView
        self.addSubview(view)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Gesture recognizer for the cover image
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        self.coverImageView.addGestureRecognizer(singleTap)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.bottomBar.effect = blurEffect
   
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS

    func setCoverImage(with url: URL?) {
        if let url = url {
            coverImageView.kf.setImage(with: url)
        } else {
            coverImageView.image = UIImage(named: "MountainsDefault")
        }
    }
    
    // Actions
    @objc func tapDetected(_ gesture: UITapGestureRecognizer) {
        self.delegate?.coverImage?(view: self, coverImageDidPressWith: gesture)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var bottomBar: UIVisualEffectView!
    @IBOutlet weak var leftButtonIcon: UIButton!
    @IBAction func pressLeftButton(_ sender: Any) {
        self.delegate?.coverImage?(view: self, leftButtonIconDidPress: self.leftButtonIcon)
    }
    @IBOutlet weak var leftLebel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - LIFE CYCLE

}
