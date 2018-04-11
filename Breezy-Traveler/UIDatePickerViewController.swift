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
            
        }
    }
    
    var endDate: Date?
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet var tableView: UITableView!
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITitleClearButtonTableViewCell.nib(), forCellReuseIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier)
        tableView.register(UIDatePickerTableViewCell.nib(), forCellReuseIdentifier: UIDatePickerTableViewCell.reuseIdentifier)
    }
}

extension UIDatePickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: RETURN VALUES
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Start Date"
        } else {
            return "End Date"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
                
                if let startDate = self.startDate {
                    let dateText = String(date: startDate, formatterMap: .Month_fullName, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
                    cell.labelTitle.text = dateText
                    cell.buttonClear.isHidden = false
                } else {
                    cell.labelTitle.text = "Add a Start Date"
                    cell.buttonClear.isHidden = false
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                
                cell.datePicker.datePickerMode = .date
                
                startDatePicker = cell.datePicker
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                cell.datePicker.datePickerMode = .date
                
                endDatePicker = cell.datePicker
                
                return cell
            }
        }
    }
    
    // MARK: VOID METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        
        if indexPath.section == 0 {
            if self.startDate == nil {
                
                // set start date to default: tomorrow's
                self.startDate = Date(timeIntervalSinceNow: CTDateComponentDay).midnight
            }
        } else {
            
        }
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}
