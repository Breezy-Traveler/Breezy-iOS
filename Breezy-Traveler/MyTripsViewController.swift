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
    
    var trips = [Trip]()
    
    let networkStack = NetworkStack()
    let testUser = BTUser(id: 1, name: "Phyllis", username: "Phyllis", password: "test123", email: "phyllis@gmail.com", token: "a80fe30858c8c519c7a9a509bc14f1e1")

    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        networkStack.loadUserTrips(user: testUser) { (result) in
            switch result {
                
            case .success(let tripsDictionaries):                                
                    self.trips = tripsDictionaries
                    DispatchQueue.main.async {
                        self.tripsTableView.reloadData()
                    }
                
            case .failure(let tripsErrors):
                print(tripsErrors.errors)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return trips.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTripsTVCell
            
            cell.tripsCollectionView.delegate = self
            cell.tripsCollectionView.dataSource = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as! TripsTVCell
            
            let trip = trips[indexPath.row]
            
            if let startDate = trip.startDate, let endDate = trip.endDate {
                cell.startDate.text = startDate.description
                cell.endDate.text = endDate.description
            }
            cell.placeName.text = trip.place
            cell.isPublic.text = trip.isPublic.description
            
            tableView.rowHeight = 80
            return cell
        }
        
    }

}

extension MyTripsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreTripCell", for: indexPath) as! ExploreTripsCollectionViewCell
        
        return cell
    }
    
    // Swipe left actions: edit and delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            print("Delete Action Tapped")
            let deleteTrip = self.trips[indexPath.row]
            // item to delete
            print(deleteTrip)
            // delete data from the inventories array
            self.trips.remove(at: indexPath.row)
            
            // delete the row from the tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // delete trip from the database
            self.networkStack.deleteTrip(trip: deleteTrip, callback: { (result) in
                switch result {
                    
                case .success(_):
                    print("\(deleteTrip.place)\n was deleted")
                    DispatchQueue.main.async {
                        self.tripsTableView.reloadData()
                    }
                    print(deleteTrip)
                case .failure(let tripsErrors):
                    print(tripsErrors.errors)
                }
            })
        }
        
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 80.0)
    }
    
}
