//
//  UIDatePickerTableViewCell.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/11/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

@objc protocol UIDatePickerTableViewCellDelegate: class {
    @objc optional func datePicker(cell: UIDatePickerTableViewCell, datePicker: UIDatePicker, didChangeTo newDate: Date)
}

class UIDatePickerTableViewCell: UITableViewCell {
    
    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static let nibName = "UIDatePickerTableViewCell"
    static let reuseIdentifier = "date picker cell"
    
    weak var delegate: UIDatePickerTableViewCellDelegate?

    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func didChangeDate(_ sender: Any) {
        delegate?.datePicker?(cell: self, datePicker: datePicker, didChangeTo: datePicker.date)
    }
    
    // MARK: - LIFE CYCLE
    
}
