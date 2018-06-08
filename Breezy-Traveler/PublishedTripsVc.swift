//
//  PublishedTripsVc.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/8/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class PublishedTripsVc: UIViewController {
    
    private var networkStack = NetworkStack()
    
    private var publishedTrips = [BTTrip]() {
        didSet {
            table.reloadData()
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let identifier = segue.identifier {
     switch identifier {
     case <#pattern#>:
     <#code#>
     default:
     break
     }
     }
     }*/
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkStack.loadPublishedTrips(fetchAllTrips: true) { (result) in
            switch result {
            case .success(let trips):
                self.publishedTrips = trips
            case .failure(let err):
                UIAlertController(
                    title: "Published Trips",
                    message: "Failed to load published trips. Error: \(err.localizedDescription)",
                    preferredStyle: .alert)
                    .addDismissButton()
                    .present(in: self)
            }
        }
    }
}

extension PublishedTripsVc: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: RETURN VALUES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishedTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "published trip cell", for: indexPath) as! PublishedTripTableViewCell
        
        let trip = publishedTrips[indexPath.row]
        cell.configure(trip)
        
        return cell
    }
    
    // MARK: METHODS
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}

