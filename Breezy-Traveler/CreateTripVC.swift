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
    
    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedSave(_ sender: UIBarButtonItem) {
        guard let place = try? placeTextField.text.sanitizing(with: .trimmed, .notEmpty) else {
            return presentAlert(error: "place cannot be empty")
        }
        
        let newTrip = CreateTrip(place: place)
        
        let loading = LoadingViewController()
        loading.present()
        
        networkStack.createTrip(trip: newTrip) { [weak self] (result) in
            loading.dismiss {
                guard let unwrappedSelf = self else { return }
                
                switch result {
                    
                case .success(let trip):
                    print(trip)
                    
                    // Navigate to Trip Detail
                    let tripStoryboard : UIStoryboard = UIStoryboard(name: "Trips", bundle:nil)
                    let vc = tripStoryboard.instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailedViewController
                    
                    // Bring back to the main thread before presenting the Trip Detail View
                    DispatchQueue.main.async {
                        vc.trip = trip
                        unwrappedSelf.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case .failure(let err):
                    unwrappedSelf.presentAlert(
                        error: err,
                        title: "Creating a Trip"
                    )
                }
            }
        }
    }
}
