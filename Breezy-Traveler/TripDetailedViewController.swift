//
//  TripDetailedViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripDetailedViewController: UIViewController {
    
    private lazy var viewModel = TripDetailedViewModel(delegate: self)
    
    var trip: BTTrip {
        set {
            self.viewModel.trip = newValue
        }
        get {
            return self.viewModel.trip
        }
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        
        self.title = trip.place
        
        // layout cover image
        let likesTitle = viewModel.likesText
        coverImage.leftButton.setTitleWithoutAnimation(likesTitle, for: .normal)
        let publishedTitle = viewModel.publishedText
        coverImage.rightButton.setTitleWithoutAnimation(publishedTitle, for: .normal)
        
        // layout dates
        buttonDates.subtitleLabel.text = viewModel.dateRangesSubtitle
        
        // layout hotels and sites
        buttonHotels.subtitleLabel.text = viewModel.hotelSubtitle
        buttonStites.subtitleLabel.text = viewModel.siteSubtitle
        
        // layout notes
        buttonNotes.subtitleLabel.text = viewModel.notesSubtitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case UIStoryboardSegue.showDatePicker:
                //TODO: prepare show date picker
                break
            case UIStoryboardSegue.showHotels:
                //TODO: prepare show hotels
                break
            case UIStoryboardSegue.showSites:
                //TODO: prepare show sites
                break
            case UIStoryboardSegue.showNotes:
                //TODO: prepare show notes
                break
            default: break
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var coverImage: UICoverImageView!
    
    @IBOutlet weak var buttonDates: UIButtonCell!
    @IBAction func pressDates(_ sender: Any) {
        self.performSegue(withIdentifier: UIStoryboardSegue.showDatePicker, sender: nil)
    }
    
    @IBOutlet weak var buttonHotels: UIButtonCell!
    @IBAction func pressHotels(_ sender: Any) {
        self.performSegue(withIdentifier: UIStoryboardSegue.showHotels, sender: nil)
    }
    
    @IBOutlet weak var buttonStites: UIButtonCell!
    @IBAction func pressSites(_ sender: Any) {
        self.performSegue(withIdentifier: UIStoryboardSegue.showSites, sender: nil)
    }
    
    @IBOutlet weak var buttonNotes: UIButtonCell!
    @IBAction func pressNotes(_ sender: Any) {
        self.performSegue(withIdentifier: UIStoryboardSegue.showNotes, sender: nil)
    }

    @IBAction func pressRenamePlace(_ sender: Any) {
        let tripPlace = viewModel.tripPlace
        let alertPlace = UIAlertController(title: "Update Place", message: "enter a new place", preferredStyle: .alert)
        
        alertPlace
            .addTextField(defaultText: tripPlace, placeholderText: "trip's place")
            .addConfirmationButton(title: "Rename") { [unowned self] (action) in
                guard let newPlace = alertPlace.inputField.text else {
                    return debugPrint("no text was in the text field")
                }
                
                self.viewModel.updatePlace(with: newPlace)
            }
            .present(in: self)
    }
}

extension TripDetailedViewController: TripDetailedViewModelDelegate {
    func viewModel(_ model: TripDetailedViewModel, didUpdate trip: BTTrip) {
        self.updateUI()
    }
    
    func viewModel(_ model: TripDetailedViewModel, didRecieve errors: [String]) {
        let combinedErrorMessages = errors.reduce("errors: ") { "\($0) \($1). " }
        UIAlertController(title: "Something Went Wrong", message: combinedErrorMessages, preferredStyle: .alert)
            .addDismissButton()
            .present(in: self)
    }
}

extension TripDetailedViewController: UICoverImageViewDelegate {
    
    func coverImage(view: UICoverImageView, leftButtonDidPress button: UIButton) {
    }
    
    func coverImage(view: UICoverImageView, rightButtonDidPress button: UIButton) {
        
        //pressed publish button
        self.viewModel.toggleIsPublished()
    }
    
}

fileprivate extension UIStoryboardSegue {
    static var showDatePicker: String {
        return "show date picker"
    }
    
    static var showHotels: String {
        return "show hotels"
    }
    
    static var showSites: String {
        return "show sites"
    }
    
    static var showNotes: String {
        return "show notes"
    }
}
