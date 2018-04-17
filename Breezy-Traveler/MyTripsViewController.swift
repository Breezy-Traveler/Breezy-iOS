//
//  MyTripsViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {
    
    private var trips = [BTTrip]()
    private var publishedTrips: [BTTrip]?
    var currentUser = BTUser.getStoredUser()
    var userPersitence = UserPersistence()
    let networkStack = NetworkStack()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    
    func setupProfileImage() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        if let savedProfileImage = userPersitence.loadUserProfileImage() {
            profileImage.image = savedProfileImage
        }
    }
    
    func setupUserDataDisplay() {
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
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
    
    func loadPublishedTrips() {
        networkStack.loadPublishedTrips(fetchAllTrips: false) { (result) in
            switch result {
            case .success(let publishedTrips):
                self.publishedTrips = publishedTrips
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                
                //TODO: present errors differently, perhaps
                // prompt user of error
                UIAlertController(title: "Fetching Published Trips", message: err.localizedDescription, preferredStyle: .alert)
                    .addDismissButton()
                    .present(in: self)
            }
        }
    }
    
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
            case "show published trip detailed":
                guard let vc = segue.destination as? TripDetailedViewController else {
                    fatalError("segue was not set up correctly in the storyboard")
                }
                
                guard
                    let cell = sender as? UICollectionViewCell,
                    let indexPath = self.collectionView.indexPath(for: cell) else {
                        fatalError("this segue identifer was triggered by something else other than a UICollectionViewCell Cell")
                }
                let selectedTrip = self.publishedTrips![indexPath.row]
                
                vc.trip = selectedTrip
            default: break
            }
        }
    }
    
    // MARK: - IBACTIONS
    @IBOutlet weak var tripsTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func unwindToMyTrips(_ segue: UIStoryboardSegue) {
        debugPrint("welcome back, unwind!")
    }
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserDataDisplay()
        setupProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserTrips()  
        loadPublishedTrips()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set the navigation bar appearence for this viewController
//        let nav = self.navigationController?.navigationBar
//
//
//        title = "Breezy Traveler"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedStringKey.font: UIFont(name: "Absolute-Regular", size: 20)!
//        ]
//
//        // 2 Set the style for the bar
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.white
//        nav?.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        
        // 3 Add our logo in text in the Nav Bar for this screen
//        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//        labelView.textColor = UIColor.white
////        let font = UIFont(name: "Avenir-Next", size: 20)
//        labelView.font = UIFont(name: "Absolute-Regular", size: 20)
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.contentMode = .scaleAspectFit
        
        // 4 Set the text in the label
//        let text = "Breezy Traveler"
//        let image = UIImage(named: "BreezyTravelerLogo")
//        labelView.text = text
//        imageView.image = image
        
        // 5
//        navigationItem.titleView = labelView
    }
}


extension MyTripsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "My Trips"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        // MARK: Display all trips for a user
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as! TripsTVCell
        
        let trip = trips[indexPath.row]
        cell.configure(trip)
        
        tableView.rowHeight = 80
        return cell
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
        return self.publishedTrips?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreTripCell", for: indexPath) as! ExploreTripsCollectionViewCell
        
        let trip = self.publishedTrips![indexPath.row]
        cell.configure(trip)
        
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
