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
                self.startDatePicker?.setDate(newValue, animated: true)
            } else {
                // hide the picker cell
            }
            tableView?.reloadRows(at: [UIDatePickerViewController.startDateTitle], with: .fade)
        }
    }
    
    var endDate: Date? {
        didSet {
            if let newValue = self.endDate {
                self.endDatePicker?.setDate(newValue, animated: true)
            } else {
                // hide the picker cell
            }
            tableView?.reloadRows(at: [UIDatePickerViewController.endDateTitle], with: .fade)
        }
    }
    
    private enum ViewState {
        case ShowingNoPicker
        case ShowingStartDatePicker
        case ShowingEndDatePicker
    }
    
    private var viewState: ViewState = .ShowingNoPicker {
        didSet {
            
            // if the same state was set, toggle to Showing no picker
            if oldValue == self.viewState {
                self.viewState = .ShowingNoPicker
            } else {
                self.updateUI()
            }
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        UIView.animate(withDuration: 0.45) { [unowned self] in
            switch self.viewState {
            case .ShowingNoPicker:
                self.startDatePicker.isHidden = true
                self.endDatePicker.isHidden = true
            case .ShowingStartDatePicker:
                self.startDatePicker.isHidden = false
                self.endDatePicker.isHidden = true
            case .ShowingEndDatePicker:
                self.startDatePicker.isHidden = true
                self.endDatePicker.isHidden = false
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet var tableView: UITableView!
    private weak var startDateCell: UITitleClearButtonTableViewCell!
    private weak var startDatePicker: UIDatePicker!
    private weak var endDateCell: UITitleClearButtonTableViewCell!
    private weak var endDatePicker: UIDatePicker!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITitleClearButtonTableViewCell.nib(), forCellReuseIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier)
        tableView.register(UIDatePickerTableViewCell.nib(), forCellReuseIdentifier: UIDatePickerTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                cell.delegate = self
                
                self.startDateCell = cell
                return cell
            } else {
                
                // Start Date Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                cell.datePicker.datePickerMode = .date
                cell.datePicker.date = self.startDate ?? Date()
                
                self.startDatePicker = cell.datePicker
                return cell
            }
        } else {
            if indexPath.row == 0 {
                
                // End Date Title
                let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
                
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
                return cell
            } else {
                
                // End Date Picker
                let cell = tableView.dequeueReusableCell(withIdentifier: UIDatePickerTableViewCell.reuseIdentifier, for: indexPath) as! UIDatePickerTableViewCell
                
                cell.datePicker.datePickerMode = .date
                cell.datePicker.date = self.endDate ?? Date()
                
                self.endDatePicker = cell.datePicker
                return cell
            }
        }
    }
    
    // MARK: VOID METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        
        if indexPath.section == 0 {
            if self.startDate == nil {
                
                // set start date to default: tomorrow
                self.startDate = Date(timeIntervalSinceNow: CTDateComponentDay)
            } else {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            self.viewState = .ShowingStartDatePicker
        } else {
            if self.startDate != nil {
                
                if self.endDate == nil {
                    
                    // set start date to default: a week from now
                    self.endDate = Date(timeIntervalSinceNow: CTDateComponentWeek)
                } else {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                
                // set start date to default: a week from now
                if self.endDate == nil {
                    self.endDate = Date(timeIntervalSinceNow: CTDateComponentWeek)
                }
            }
            self.viewState = .ShowingEndDatePicker
        }
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}

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
