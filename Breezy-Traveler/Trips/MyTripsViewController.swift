//
//  MyTripsViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tripsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTripsTVCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as! TripsTVCell
            tableView.rowHeight = 80
            return cell
        }
        
    }

   

}
