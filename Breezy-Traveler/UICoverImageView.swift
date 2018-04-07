//
//  UICoverImageView.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

@objc protocol UICoverImageViewDelegate: class {
    @objc optional func coverImage(view: UICoverImageView, leftButtonDidPress button: UIButton)
    @objc optional func coverImage(view: UICoverImageView, rightButtonDidPress button: UIButton)
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
        
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var leftIconView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBAction func pressLeftButton(_ sender: Any) {
        self.delegate?.coverImage?(view: self, leftButtonDidPress: self.leftButton)
    }
    
    @IBOutlet weak var rightIconView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBAction func rightLeftButton(_ sender: Any) {
        self.delegate?.coverImage?(view: self, rightButtonDidPress: self.rightButton)
    }
    
    // MARK: - LIFE CYCLE

}
