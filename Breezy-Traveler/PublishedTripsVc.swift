//
//  PublishedTripsVc.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 6/8/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Result //TODO: remove after writing implementation of networkStack.loadTrips(for searchTerm: .., ...)

class PublishedTripsVc: UIViewController {
    
    private var networkStack = NetworkStack()
    
    private var publishedTrips = [BTTrip]() {
        didSet {
            table.reloadData()
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show detailed published trip":
                guard let vc = segue.destination as? TripDetailedViewController else {
                    fatalError("segue was not set up correctly in the storyboard")
                }
                
                guard
                    let cell = sender as? UITableViewCell,
                    let indexPath = self.table.indexPath(for: cell) else {
                        fatalError("this segue identifer was triggered by something else other than a UITableView Cell")
                }
                let selectedTrip = self.publishedTrips[indexPath.row]
                
                vc.trip = selectedTrip
            default: break
            }
        }
    }
    
    private func reloadTable(for trips: [BTTrip]? = nil) {
        if let newTrips = trips {
            self.publishedTrips = newTrips
        }
        
        table.reloadData()
    }
    
    private func loadTrips(for searchTerm: String) {
        networkStack.loadPublishedTrips(for: searchTerm) { [weak self] result in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let trips):
                unwrappedSelf.reloadTable(for: trips)
            case .failure(let err):
                UIAlertController(
                    title: "Published Trips",
                    message: "Failed to load published trips. Error: \(err.description)",
                    preferredStyle: .alert)
                    .addDismissButton()
                    .present(in: unwrappedSelf)
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkStack.loadPublishedTrips(fetchAllTrips: true) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }
            
            switch result {
            case .success(let trips):
                unwrappedSelf.reloadTable(for: trips)
            case .failure(let err):
                UIAlertController(
                    title: "Published Trips",
                    message: "Failed to load published trips. Error: \(err.description)",
                    preferredStyle: .alert)
                    .addDismissButton()
                    .present(in: unwrappedSelf)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PublishedTripsVc: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            loadTrips(for: searchTerm)
        }
    }
}

