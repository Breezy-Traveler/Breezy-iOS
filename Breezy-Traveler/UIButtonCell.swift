//
//  UIButtonCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class UIButtonCell: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layoutNib()
    }
    
    private func layoutNib() {
        self.view = Bundle.main.loadNibNamed("UIButtonCell", owner: self, options: nil)?.first! as! UIView
        self.addSubview(view)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.titleLabel.text = "Blank"
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func pressButton(_ button: UIButton) {
        
    }
    
    // MARK: - LIFE CYCLE
}
