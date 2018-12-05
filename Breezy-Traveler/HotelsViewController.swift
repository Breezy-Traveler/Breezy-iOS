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
        
        //TODO: erick-testing purposes
//        let hotel = CreateHotel.init(name: "LA", address: "1234 Infinity Circle")
//        NetworkStack().create(a: hotel, for: self.trip) { (result) in
//            switch result {
//            case .success(let createdHotel):
//                print(createdHotel)
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
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
