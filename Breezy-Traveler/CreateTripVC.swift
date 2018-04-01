//
//  CreateTripVC.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/1/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class CreateTripVC: UIViewController {
    
    
    let networkStack = NetworkStack()
    
    @IBOutlet weak var placeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func coverImage(_ sender: Any) {
        
    }
    
    
    @IBAction func saveTrip(_ sender: UIBarButtonItem) {
        guard let place = placeTextField.text else {
            return
        }
        
        let trip = Trip(place: place, startDate: nil, endDate: nil, hotels: [], sites: [], isPublic: false)
        
        
        networkStack.createTrip(trip: trip) { (result) in
            switch result {
                
            case .success(let trip):
                print(trip)
                
                // Go back to My Trips View Controller
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let tripsErrors):
                print(tripsErrors.errors)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
