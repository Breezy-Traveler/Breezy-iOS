//
//  SitesViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/7/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class SitesViewController: ResourceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SitesViewModel(trip: self.trip)
    }
}
