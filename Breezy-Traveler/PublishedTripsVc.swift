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
    
    private var publishedTrips = [Trip]() {
        didSet {
            table.reloadData()
        }
    }
    
    // MARK: - RETURN VALUES
    
    deinit {
        reset(onceKey: "published trips")
    }
    
    // MARK: - METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show detailed published trip":
                guard let vc = segue.destination as? TripDetailedViewController else {
                    fatalError("segue was not set up correctly in the storyboard")
                }
                
                guard
                    let indexPath = sender as? IndexPath else {
                        fatalError("this segue identifer was triggered by something else other than a UITableView Cell")
                }
                let selectedTrip = self.publishedTrips[indexPath.row]
                
                vc.trip = selectedTrip
            default: break
            }
        }
    }
    
    /**
     reloads the table
     
     - parameter trips: if not nil, `publishedTrips` is updated to the given trips
     */
    private func reloadTable(for trips: [Trip]? = nil) {
        if let newTrips = trips {
            self.publishedTrips = newTrips
        }
        
        table.reloadData()
        table.contentOffset = CGPoint.zero
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
                    message: "Failed to load published trips. Error: \(err.localizedDescription)",
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
        
        table.register(TripsTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        once("published trips") {
            networkStack.loadPublishedTrips(fetchAllTrips: true) { [weak self] (result) in
                guard let unwrappedSelf = self else { return }
                
                switch result {
                case .success(let trips):
                    unwrappedSelf.reloadTable(for: trips)
                case .failure(let err):
                    UIAlertController(
                        title: "Published Trips",
                        message: "Failed to load published trips. Error: \(err.localizedDescription)",
                        preferredStyle: .alert)
                        .addDismissButton()
                        .present(in: unwrappedSelf)
                }
            }
        }
        
        if let selectedRow = table.indexPathForSelectedRow {
            table.deselectRow(at: selectedRow, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as! TripsTVCell
        
        let trip = publishedTrips[indexPath.row]
        cell.configure(published: trip)
        
        return cell
    }
    
    // MARK: METHODS
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "show detailed published trip", sender: indexPath)
    }
    
    // MARK: IBACTIONS
    
    // MARK: LIFE CYCLE
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PublishedTripsVc: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            loadTrips(for: searchTerm)
            
            searchBar.resignFirstResponder()
        }
    }
}

