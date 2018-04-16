//
//  UITitleClearButtonTableViewCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/11/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

@objc protocol UITitleClearButtonTableViewCellDelegate: class {
    @objc optional func titleClear(cell: UITitleClearButtonTableViewCell, clearButtonDidTap: UIButton)
}

class UITitleClearButtonTableViewCell: UITableViewCell {
    
    
    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static let nibName = "UITitleClearButtonTableViewCell"
    static let reuseIdentifier = "clear title cell"
    
    weak var delegate: UITitleClearButtonTableViewCellDelegate?
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonClear: UIButton!
    @IBAction func pressClear(_ sender: Any) {
        delegate?.titleClear?(cell: self, clearButtonDidTap: buttonClear)
    }
    
    // MARK: - LIFE CYCLE
    
}
