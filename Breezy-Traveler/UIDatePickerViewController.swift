//
//  UIDatePickerViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/11/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class UIDatePickerViewController: UIViewController {
    
    var startDate: Date? {
        didSet {
            self.tableView?.reloadRows(at: [UIDatePickerViewController.startDateTitle], with: .fade)
        }
    }
    
    var endDate: Date? {
        willSet {
            
            // can't have a end date without setting a start date
            if newValue != nil, self.startDate == nil {
                self.startDate = Date()
            }
        }
        didSet {
            tableView?.reloadRows(at: [UIDatePickerViewController.endDateTitle], with: .fade)
        }
    }
    
    private weak var startDateCell: UITitleClearButtonTableViewCell!
    private weak var endDateCell: UITitleClearButtonTableViewCell!
    
    var tableView: UITableView! {
        return self.view as! UITableView?
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITitleClearButtonTableViewCell.nib(), forCellReuseIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier)
    }
    
}

fileprivate extension UIDatePickerViewController {
    static let startDateTitle = IndexPath(row: 0, section: 0)
    static let endDateTitle = IndexPath(row: 1, section: 0)
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension UIDatePickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: RETURN VALUES
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Start and End Dates"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
        
        if indexPath == UIDatePickerViewController.startDateTitle {
            
            // Start Date Title
            if let startDate = self.startDate {
                let dateText = String(date: startDate, formatterMap: .Month_fullName, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
                cell.labelTitle.text = dateText
                cell.buttonClear.isHidden = false
            } else {
                cell.labelTitle.text = "Add a Start Date"
                cell.buttonClear.isHidden = true
            }
            cell.delegate = self
            
            self.startDateCell = cell
        } else {
            
            // End Date Title
            if let endDate = self.endDate {
                let dateText = String(date: endDate, formatterMap: .Month_fullName, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
                cell.labelTitle.text = dateText
                cell.buttonClear.isHidden = false
            } else {
                cell.labelTitle.text = "Add an End Date"
                cell.buttonClear.isHidden = true
            }
            cell.delegate = self
            
            self.endDateCell = cell
        }
        cell.delegate = self
        
        return cell
    }
    
    // MARK: VOID METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}

// MARK: - UITitleClearButtonTableViewCellDelegate

extension UIDatePickerViewController: UITitleClearButtonTableViewCellDelegate {
    func titleClear(cell: UITitleClearButtonTableViewCell, clearButtonDidTap: UIButton) {
        if self.startDateCell === cell {
            self.startDate = nil
            
            // can't have a end date without a start date
            if self.endDate != nil {
                self.endDate = nil
            }
        } else if self.endDateCell === cell {
            self.endDate = nil
        } else {
            assertionFailure("clear button did tap for unknown cell")
        }
    }
}

