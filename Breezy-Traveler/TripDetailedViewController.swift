//
//  TripDetailedViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class TripDetailedViewController: UIViewController {
    
    private var viewModel = TripDetailedViewModel()
    
    var trip: BTTrip {
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
        
        // shadow
        labelTitle.layer.shadowColor = UIColor.black.cgColor
        labelTitle.layer.shadowRadius = 2.0
        labelTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        labelTitle.layer.shadowOpacity = 0.85
        
        // Cover Image
        let likesTitle = viewModel.likesText
        coverImage.leftButton.setTitle(likesTitle, for: .normal)
        
        let publishedTitle = viewModel.publishedText
        coverImage.rightButton.setTitle(publishedTitle, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func updateUI() {
        
        labelTitle.text = trip.place
        
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
    
    @IBOutlet weak var labelTitle: UILabel!
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

}

extension TripDetailedViewController: UICoverImageViewDelegate {
    
    func coverImage(view: UICoverImageView, leftButtonDidPress button: UIButton) {
    }
    
    func coverImage(view: UICoverImageView, rightButtonDidPress button: UIButton) {
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
