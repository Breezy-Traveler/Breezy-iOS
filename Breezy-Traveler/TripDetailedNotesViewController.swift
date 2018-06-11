//
//  TripDetailedNotesViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/9/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

protocol TripDetailedNotesDelegate: class {
    func tripDetailedNotes(_ tripsDetailedNotesViewController: TripDetailedNotesViewController, didFinishWith notes: String)
}

class TripDetailedNotesViewController: UIViewController {
    
    var notes: String!
    
    weak var delegate: TripDetailedNotesDelegate?

    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var textviewNotes: UITextView!
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textviewNotes.text = self.notes
        
        textviewNotes.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.tripDetailedNotes(self, didFinishWith: textviewNotes.text)
        
        textviewNotes.resignFirstResponder()
    }

}
