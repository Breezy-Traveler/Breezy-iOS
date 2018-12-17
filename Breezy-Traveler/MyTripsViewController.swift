//
//  MyTripsViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {
    
    // MARK: - VARS
    
    private var trips = [Trip]()
    private var publishedTrips: [Trip]?
    
    var userPersistence = UserPersistence()
    let networkStack = NetworkStack()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func setupProfileImage() {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    func loadUserTrips() {
        networkStack.loadUserTrips(user: UserPersistence.currentUser) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }

            switch result {
                
            case .success(let tripsDictionaries):
                unwrappedSelf.trips = tripsDictionaries
                DispatchQueue.main.async {
                    unwrappedSelf.tripsTableView.reloadData()
                }
                
            case .failure(let tripsErrors):
                print(tripsErrors.errors)
            }
        }
    }
    
    func loadPublishedTrips() {
        //TODO: published trips
        return ()
        
        networkStack.loadPublishedTrips(fetchAllTrips: false) { [weak self] (result) in
            guard let unwrappedSelf = self else { return }

            switch result {
            case .success(let publishedTrips):
                unwrappedSelf.publishedTrips = publishedTrips
                DispatchQueue.main.async {
                    unwrappedSelf.collectionView.reloadData()
                }
            case .failure(let err):
                
                //TODO: present errors differently, perhaps
                // prompt user of error
                UIAlertController(title: "Fetching Published Trips", message: err.localizedDescription, preferredStyle: .alert)
                    .addDismissButton()
                    .present(in: unwrappedSelf)
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
                    let indexPath = sender as? IndexPath else {
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
    
    private func updateUI() {
        if let savedProfileImage = userPersistence.userProfileImage {
            profileImage.image = savedProfileImage
        }
        
        let user = UserPersistence.currentUser
        usernameLabel.text = user.username
        emailLabel.text = user.email
        
        loadUserTrips()
        loadPublishedTrips()
    }
    
    private func listenForUserLogout() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidLogout(_:)), name: NSNotification.Name.userDidLogout, object: nil)
    }
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tripsTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var singleTap: UITapGestureRecognizer!
    
    // MARK: - ACTIONS
    
    @IBAction func unwindToMyTrips(_ segue: UIStoryboardSegue) {
        debugPrint("welcome back, unwind!")
    }
    
    @IBAction func tapDetected() {
        print("Imageview Clicked")
        // Initialize the new storyboard in code,
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Initialize the new view controller in code using a storyboard identifier
        let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        // and then use the navigation controller to segue to it.
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc private func userDidLogout(_ notification: Notification) {
        trips = []
        tripsTableView.reloadData()
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImage()
        setupNavigationBarAppearence()
        listenForUserLogout()
        profileImage.addGestureRecognizer(singleTap)
        tripsTableView.register(TripsTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userPersistence.checkIfUserIsLoggedIn() {
            updateUI()
            //TODO: show loading indicator
        } else {
            let loginViewController = LoginController()
            present(loginViewController, animated: false, completion: nil)
        }
        
        if let selectedRow = tripsTableView.indexPathForSelectedRow {
            tripsTableView.deselectRow(at: selectedRow, animated: true)
        }
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
    
      
        tableView.rowHeight = screenSize.height / 6.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "show trip detailed", sender: indexPath)
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
            networkStack.deleteTrip(trip: deleteTrip, callback: { [weak self] (result) in
                guard let unwrappedSelf = self else { return }

                switch result {
                    
                case .success(_):
                    print("\(deleteTrip.place)\n was deleted")
                    DispatchQueue.main.async {
                        unwrappedSelf.tripsTableView.reloadData()
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
        let rowHeight = screenSize.height / 6.0
        
        return CGSize(width: 100.0, height: rowHeight)
    }
    
    // Make the Status Bar Light/Dark Content for this View
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
}
