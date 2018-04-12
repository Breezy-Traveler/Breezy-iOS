//
//  TripDatePickerViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/11/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

protocol TripDatePickerViewControllerDelegate: class {
    func tripDatePicker(_ tripViewController: TripDatePickerViewController, didFinishSelecting startDate: Date?, endDate: Date?)
    func tripDatePicker(_ tripViewController: TripDatePickerViewController, didCancel startDate: Date?, endDate: Date?)
}

class TripDatePickerViewController: UITableViewController {
    
    var startDate: Date? {
        didSet {
            self.tableView?.reloadRows(at: [TripDatePickerViewController.startDateTitle], with: .fade)
        }
    }
    
    var endDate: Date? {
        willSet {
            
            // can't have a end date without setting a start date
            if let newEndDate = newValue, self.startDate == nil {
                
                // set start date one day before the new end date
                self.startDate = newEndDate.addingTimeInterval(-CTDateComponentDay)
            }
        }
        didSet {
            tableView?.reloadRows(at: [TripDatePickerViewController.endDateTitle], with: .fade)
        }
    }
    
    weak var delegate: TripDatePickerViewControllerDelegate?
    
    private weak var startDateCell: UITitleClearButtonTableViewCell!
    private weak var endDateCell: UITitleClearButtonTableViewCell!
    
    // MARK: - RETURN VALUES
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Start and End Dates"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier, for: indexPath) as! UITitleClearButtonTableViewCell
        
        if indexPath == TripDatePickerViewController.startDateTitle {
            
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
    
    // MARK: - VOID METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datePickerVc = UIDatePickerViewController.loadFrom(nibName: nil)
        datePickerVc.delegate = self
        datePickerVc.datePickerMode = .date
        
        if indexPath == TripDatePickerViewController.startDateTitle {
            if let dateValue = self.startDate {
                datePickerVc.date = dateValue
            }
            if self.endDate != nil {
                datePickerVc.datePickerMaxDate = self.endDate!
            }
        } else {
            if let dateValue = self.endDate {
                datePickerVc.date = dateValue
            }
            if self.startDate != nil {
                datePickerVc.datePickerMinDate = self.startDate!
            }
        }
        
        datePickerVc.modalPresentationStyle = .overCurrentContext
        datePickerVc.modalTransitionStyle = .crossDissolve
        self.present(datePickerVc, animated: true)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pressDone(_ sender: Any) {
        self.delegate?.tripDatePicker(self, didFinishSelecting: self.startDate, endDate: self.endDate)
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        self.delegate?.tripDatePicker(self, didCancel: self.startDate, endDate: self.endDate)
    }
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITitleClearButtonTableViewCell.nib(), forCellReuseIdentifier: UITitleClearButtonTableViewCell.reuseIdentifier)
    }
    
}

fileprivate extension TripDatePickerViewController {
    static let startDateTitle = IndexPath(row: 0, section: 0)
    static let endDateTitle = IndexPath(row: 1, section: 0)
}

// MARK: - UITitleClearButtonTableViewCellDelegate

extension TripDatePickerViewController: UITitleClearButtonTableViewCellDelegate {
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

// MARK: - UIDatePickerViewControllerDelegate

extension TripDatePickerViewController: UIDatePickerViewControllerDelegate {
    func datePicker(_ viewController: UIDatePickerViewController, didFinishPicking date: Date) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return assertionFailure("no selected index path")
        }
        
        if selectedIndexPath == TripDatePickerViewController.startDateTitle {
            self.startDate = date
        } else {
            self.endDate = date
        }
    }
}

