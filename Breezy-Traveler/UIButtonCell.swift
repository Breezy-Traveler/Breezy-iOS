//
//  UIButtonCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonCell: UIControl {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layoutNib()
    }
    
    private func layoutNib() {
        self.view = Bundle.main.loadNibNamed("UIButtonCell", owner: self, options: nil)?.first! as! UIView
        self.addSubview(view)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.button.addTarget(self, action: #selector(UIButtonCell.pressedCell(button:)), for: .touchUpInside)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    @objc private func pressedCell(button: UIButton) {
        self.sendActions(for: .touchUpInside)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var view: UIView!
    
    @IBInspectable
    private var title: String = "Label" {
        didSet {
            titleLabel.text = self.title
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - LIFE CYCLE
}
