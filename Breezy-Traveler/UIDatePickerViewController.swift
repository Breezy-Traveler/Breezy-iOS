//
//  UIDatePickerViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/12/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

@objc protocol UIDatePickerViewControllerDelegate: class {
    @objc optional func datePicker(_ viewController: UIDatePickerViewController, didFinishPicking date: Date)
}

class UIDatePickerViewController: UIViewController {

    weak var delegate: UIDatePickerViewControllerDelegate?

    var date: Date = Date()

    var datePickerMode: UIDatePickerMode = .dateAndTime

    var datePickerMinDate: Date?

    var datePickerMaxDate: Date?

    private var isShowingDatePicker: Bool {
        set {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveLinear, animations: { [weak self] in
                guard let unwrappedSelf = self else { return }

                if newValue {
                    unwrappedSelf.constraintBottom.constant = 0
                } else {
                    unwrappedSelf.constraintBottom.constant = -unwrappedSelf.datePicker.bounds.size.height
                }
                unwrappedSelf.view.layoutIfNeeded()
            })
        }
        get {
            return self.constraintBottom.constant == 0
        }
    }

    // MARK: - RETURN VALUES

    // MARK: - METHODS

    // MARK: - IBACTIONS
    @IBOutlet private weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBAction func didChangeDate(_ sender: Any) {

    }

    @IBAction func pressDone(_ sender: Any) {
        self.delegate?.datePicker?(self, didFinishPicking: datePicker.date)
        self.isShowingDatePicker = false

        self.presentingViewController?.dismiss(animated: true)
    }

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.datePicker.date = self.date
        self.datePicker.datePickerMode = self.datePickerMode
        self.datePicker.minimumDate = self.datePickerMinDate
        self.datePicker.maximumDate = self.datePickerMaxDate

        self.isShowingDatePicker = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
