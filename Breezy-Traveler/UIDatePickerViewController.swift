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
            if let newValue = self.startDate {
                self.startDatePicker.setDate(newValue, animated: true)
            } else {
                // hide the picker cell
            }
        }
    }
    
    var endDate: Date? {
        didSet {
            if let newValue = self.endDate {
                self.endDatePicker.setDate(newValue, animated: true)
            } else {
                // hide the picker cell
            }
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
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

fileprivate extension UIDatePickerViewController {
    static let startDateTitle = IndexPath(row: 0, section: 0)
    static let startDatePicker = IndexPath(row: 1, section: 0)
    static let endDateTitle = IndexPath(row: 0, section: 1)
    static let endDatePicker = IndexPath(row: 1, section: 1)
}

// MARK: - UITableViewDataSource, UITableViewDelegate

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
                
                // Start Date Title
                let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
                
                if let startDate = self.startDate {
                    let dateText = String(date: startDate, formatterMap: .Month_fullName, " ", .Day_ofTheMonthSingleDigit, ", ", .Year_noPadding)
                    cell.labelTitle.text = dateText
                    cell.buttonClear.isHidden = false
                } else {
                    cell.labelTitle.text = "Add a Start Date"
                    cell.buttonClear.isHidden = true
                }
                
                return cell
            } else {
                
                // Start Date Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                
                cell.datePicker.datePickerMode = .date
                
                startDatePicker = cell.datePicker
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                
                // End Date Title
                let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
                
                return cell
            } else {
                
                // End Date Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                cell.datePicker.datePickerMode = .date
                
                endDatePicker = cell.datePicker
                
                return cell
            }
        }
    }
    
    // MARK: METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        
        if indexPath.section == 0 {
            if self.startDate == nil {
                
                // set start date to default: tomorrow
                self.startDate = Date(timeIntervalSinceNow: CTDateComponentDay)
                self.tableView.reloadRows(at: [UIDatePickerViewController.startDateTitle], with: .fade)
            }
        } else {
            if self.startDate != nil {
                
                if self.endDate == nil {
                    // set start date to default: a week from now
                    self.endDate = Date(timeIntervalSinceNow: CTDateComponentWeek)
                    self.tableView.reloadRows(at: [UIDatePickerViewController.startDateTitle], with: .fade)
                }
            }
        }
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}

// MARK: - UIDatePickerTableViewCellDelegate

extension UIDatePickerViewController: UIDatePickerTableViewCellDelegate {
    func datePicker(cell: UIDatePickerTableViewCell, datePicker: UIDatePicker, didChangeTo newDate: Date) {
        if startDatePicker === datePicker {
            startDate = newDate
        } else if endDatePicker === datePicker {
            endDate = newDate
        }
    }
}
