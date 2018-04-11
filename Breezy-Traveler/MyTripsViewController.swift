//
//  MyTripsViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {
    
    var trips = [BTTrip]()
    var currentUser = BTUser.getStoredUser()
    var userPersitence = UserPersistence()
    let networkStack = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show trip detailed":
                guard let vc = segue.destination as? TripDetailedViewController else {
                    fatalError("segue was not set up correctly in the storyboard")
                }
                
                guard
                    let cell = sender as? UITableViewCell,
                    let indexPath = self.tripsTableView.indexPath(for: cell) else {
                        fatalError("this segue identifer was triggered by something else other than a UITableView Cell")
                }
                let selectedTrip = self.trips[indexPath.row]
                
                vc.trip = selectedTrip
            default: break
            }
        }
    }
    
    // MARK: - IBACTIONS
    @IBOutlet weak var tripsTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
  
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func unwindToMyTrips(_ segue: UIStoryboardSegue) {
        debugPrint("welcome back, unwind!")
    }
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()        
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        if let savedProfileImage = userPersitence.loadUserProfileImage() {
            profileImage.image = savedProfileImage
        }
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func loadUserTrips() {
        networkStack.loadUserTrips(user: currentUser) { (result) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserTrips()
    }
}

extension MyTripsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        // Display a side scrolling collection of users trips
        // Explore trips area
        if indexPath.section == 0 {
            tableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTripsTVCell
            
            cell.tripsCollectionView.delegate = self
            cell.tripsCollectionView.dataSource = self
            
            return cell
        } else {
            
            // MARK: Display all trips for a user
            
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
    
    // Swipe left actions: edit and delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
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
        default:
            break
        }
    }
}

// MARK: Collection view methods
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 80.0)
    }
    
    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
}
