//
//  TripDetailedNotesViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/9/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

protocol TripDetailedNotesDelegate: class {
    func tripDetailedNotesDidCancel(_ tripsDetailedNotesViewController: TripDetailedNotesViewController)
    func tripDetailedNotes(_ tripsDetailedNotesViewController: TripDetailedNotesViewController, didSaveWith notes: String)
}

class TripDetailedNotesViewController: UIViewController {
    
    var notes: String!
    
    var canModify: Bool = true
    
    weak var delegate: TripDetailedNotesDelegate?
    
    private let keyboard = KeyboardStack()

    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var textviewNotes: UITextView!
    @IBOutlet weak var constrainNotesHeight: NSLayoutConstraint!
    
    @IBAction func pressSave(_ button: UIBarButtonItem) {
        delegate?.tripDetailedNotes(self, didSaveWith: textviewNotes.text)
    }
    
    @IBAction func pressCancel(_ button: UIBarButtonItem) {
        delegate?.tripDetailedNotesDidCancel(self)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboard.delegate = self
        textviewNotes.isEditable = canModify
        
        if canModify == false {
            navigationItem.setRightBarButton(nil, animated: false)
            navigationItem.setLeftBarButton(nil, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textviewNotes.text = self.notes
        
        if canModify {
            textviewNotes.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textviewNotes.resignFirstResponder()
    }
}

extension TripDetailedNotesViewController: KeyboardStackDelegate {
    func keyboard(_ keyboardStack: KeyboardStack, didChangeTo newHeight: CGFloat) {
        
        //caculate the new height
        let viewHeight = view.frame.height
        let verticalPadding: CGFloat = 64
        let newHeight = viewHeight - newHeight - verticalPadding
        constrainNotesHeight.constant = newHeight
        view.layoutIfNeeded()
    }
}
