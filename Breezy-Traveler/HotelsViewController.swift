//
//  TripHotelsViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/5/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

class HotelsViewController: UIViewController {
    
    // MARK: - VARS
    
    var trip: Trip!
    
    //TODO: refactor to view model
    private var hotels: [Hotel] = []
    
    private var viewModel = HotelsViewModel()
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func pressAddHotel(_ sender: Any) {
        
        let newHotelAlert = UIAlertController(newHotelFor: self.trip) { [unowned self] hotelName, hotelAddress in
            self.viewModel.createHotel(name: hotelName, address: hotelAddress, for: self.trip) { isSuccessful in
                if isSuccessful {
                    self.hotels.append(Hotel(name: hotelName, address: hotelAddress))
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                } else {
                    self.presentAlert(error: nil, title: "Adding a Hotel")
                }
            }
        }
        self.present(newHotelAlert, animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchHotels(for: self.trip) { [weak self] (hotels) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.hotels = hotels
            unwrappedSelf.tableView.reloadData()
        }
    }
}

extension HotelsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.trip.place.isNotEmpty else {
            return nil
        }
        
        return "Hotels for \(self.trip.place)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HotelTVCell.identifier,
            for: indexPath
        ) as! HotelTVCell
        
        let hotel = self.hotels[indexPath.row]
        cell.configure(hotel)
        
        return cell
    }
}
