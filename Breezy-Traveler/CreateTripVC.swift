//
//  CreateTripVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/1/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class CreateTripVC: UIViewController {

    // Instance of the Moya network stack
    let networkStack = NetworkStack()
    @IBOutlet weak var placeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Performed when user taps outside of textfield
        self.hideKeyboard()
    }
    
    @IBAction func pressedSave(_ sender: UIBarButtonItem) {
        guard let place = placeTextField.text else { return }
        
        let trip = BTTrip(place: place, isPublic: false)
        networkStack.createTrip(trip: trip) { (result) in
            switch result {
                
            case .success(let trip):
                print(trip)
                
                // FIXME: Navigate to Trip Detail View
                
                let tripStoryboard : UIStoryboard = UIStoryboard(name: "Trips", bundle:nil)
                let vc = tripStoryboard.instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailedViewController
                
                // Bring back to the main thread before presenting the Trip Detail View
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
                
            case .failure(let tripsErrors):
                print(tripsErrors.errors)
            }
        }
    }
}
