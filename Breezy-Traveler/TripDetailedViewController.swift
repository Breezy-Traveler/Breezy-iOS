//
//  TripDetailedViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripDetailedViewController: UIViewController, CoverImagePickerDelegate {
    
    private lazy var viewModel = TripDetailedViewModel(delegate: self)
    
    var trip: Trip {
        set {
            self.viewModel.trip = newValue
        }
        get {
            return self.viewModel.trip
        }
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(TripDetailedViewController.pressDone(_:))
        )
        
        self.updateButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    private func updateUI() {
        
        self.title = trip.place
        
        // layout cover image
        let likesTitle = viewModel.likesText
        coverImage.leftLebel.text = String(likesTitle)
        let publishedTitle = viewModel.publishedText
        coverImage.rightLabel.text = publishedTitle
        coverImage.setCoverImage(with: trip.coverImageUrl)
        
        // layout dates
        buttonDates.subtitleLabel.text = viewModel.dateRangesSubtitle
        
        
        // layout hotels and sites
        buttonHotels.subtitleLabel.text = viewModel.hotelSubtitle
        
        buttonStites.subtitleLabel.text = viewModel.siteSubtitle
        
        // layout notes
        buttonNotes.subtitleLabel.text = viewModel.notesSubtitle
    }
    
    func updateButtonImages() {
        buttonDates.imageView.image = UIImage(named: "calendar")
        buttonHotels.imageView.image = UIImage(named: "hotel")
        buttonStites.imageView.image = UIImage(named: "site")
        buttonNotes.imageView.image = UIImage(named: "note")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case UIStoryboardSegue.showDatePicker:
                guard let vc = segue.destination as? TripDatePickerViewController else {
                    fatalError("TripDatePickerViewController was not set up in storyboard")
                }
                
                vc.delegate = self
                vc.startDate = trip.startDate
                vc.endDate = trip.endDate
            case UIStoryboardSegue.showHotels:
                //TODO: prepare show hotels
                break
            case UIStoryboardSegue.showSites:
                //TODO: prepare show sites
                break
            case UIStoryboardSegue.showNotes:
                guard let vc = segue.destination as? TripDetailedNotesViewController else {
                    fatalError("broken storyboard")
                }
                vc.notes = trip.notes
                vc.delegate = self
                
            case UIStoryboardSegue.showCollectionViewSegue:
                guard let vc = segue.destination as? ImagesViewController else {
                    fatalError("broken storyboard")
                }
                vc.coverImagePickerDelegate = self
                vc.searchTerm = trip.place
            default: break
            }
        }
    }
    
    // MARK: - Cover image method conforms to protocol
    func imageView(_ imageViewController: ImagesViewController, didSetImage imageUrl: URL) {
//        trip.coverImageUrl = imageUrl
        viewModel.updateCoverImageUrl(with: imageUrl)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var coverImage: UICoverImageView!
    
    @objc func pressDone(_ sender: Any) {
        guard let lastViewController = self.navigationController?.childViewControllers[fromBack: -2] else {
            fatalError("could not find second to last viewController in navigationController.childViewControllers")
        }
        
        // if the controller who presented this VC, by a push on the navigation controller,
        // was the Explore Trips VC, then pop this view. otherwise, unwind to the my trips VC
        if lastViewController is ExploreTripsVC {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.performSegue(withIdentifier: UIStoryboardSegue.unwindToMyTrips, sender: nil)
        }
    }
    
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
//        self.performSegue(withIdentifier: UIStoryboardSegue.showSites, sender: nil)
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
            .addConfirmationButton(title: "Rename") { [weak self] (action) in
                guard let unwrappedSelf = self else { return }

                guard let newPlace = alertPlace.inputField.text else {
                    return debugPrint("no text was in the text field")
                }
                
                unwrappedSelf.viewModel.updatePlace(with: newPlace)
            }
            .present(in: self)
    }
    
    @IBAction func pressShare(_ sender: Any) {
        if self.trip.isPublic {
            // would you like to unpublish this trip?
            UIAlertController(title: nil, message: "This trip is already published.\nWould you like to make private?", preferredStyle: .actionSheet)
                .addButton(title: "Make Private") { [unowned self] (action) in
                    
                    //pressed unpublish button
                    self.viewModel.toggleIsPublished()
                }
                .addCancelButton()
                .present(in: self)
            
        } else {
            
            // would you like to publish
            UIAlertController(title: nil, message: "Would you like to publish this trip?", preferredStyle: .actionSheet)
                .addButton(title: "Share") { [unowned self] (action) in
                    
                    //pressed publish button
                    if self.trip.coverImageUrl == nil {
                        UIAlertController(title: "Sharing", message: "You must select a cover image before sharing.", preferredStyle: .alert)
                            .addDismissButton()
                            .present(in: self)
                    } else {
                        self.viewModel.toggleIsPublished()
                    }
                }
                .addCancelButton()
                .present(in: self)
            
        }
    }
}

// MARK: - TripDetailedViewModelDelegate

extension TripDetailedViewController: TripDetailedViewModelDelegate {
    func viewModel(_ model: TripDetailedViewModel, didUpdate trip: Trip) {
        self.updateUI()
    }
    
    func viewModel(_ model: TripDetailedViewModel, didRecieve errors: [String]) {
        let combinedErrorMessages = errors.reduce("errors: ") { "\($0) \($1). " }
        print(combinedErrorMessages)
        UIAlertController(title: "Something Went Wrong", message: "Unable to publish trip", preferredStyle: .alert)
            .addDismissButton()
            .present(in: self)
    }
}

// MARK: - UICoverImageViewDelegate

extension TripDetailedViewController: UICoverImageViewDelegate {
    
    func coverImage(view: UICoverImageView, leftButtonIconDidPress button: UIButton) {
        
        // press like button
    }
    
    func coverImage(view: UICoverImageView, coverImageDidPressWith gesture: UITapGestureRecognizer) {
        print("Cover image pressed")
        
        self.performSegue(withIdentifier: "showCollectionViewSegue", sender: nil)
    }
    
}

// MARK: - TripDatePickerViewControllerDelegate

extension TripDetailedViewController: TripDatePickerViewControllerDelegate {
    func tripDatePicker(_ tripViewController: TripDatePickerViewController, didFinishSelecting startDate: Date?, endDate: Date?) {
        self.viewModel.updateDates(start: startDate, end: endDate)
        self.updateUI()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tripDatePicker(_ tripViewController: TripDatePickerViewController, didCancel startDate: Date?, endDate: Date?) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TripDetailedNotesDelegate

extension TripDetailedViewController: TripDetailedNotesDelegate {
    func tripDetailedNotes(_ tripsDetailedNotesViewController: TripDetailedNotesViewController, didFinishWith notes: String) {
        viewModel.updateNotes(with: notes)
    }
}

// MARK: - UIStoryboardSegue

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
    
    static var unwindToMyTrips: String {
        return "unwind to my trips"
    }
    
    static var showCollectionViewSegue: String {
        return "showCollectionViewSegue"
    }
}
