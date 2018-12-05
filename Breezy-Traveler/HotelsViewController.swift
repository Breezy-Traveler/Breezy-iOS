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
    
    private var viewModel = HotelsViewModel()
    
    private var hotels: [Hotel] {
        return viewModel.hotels
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    private func deleteHotel(at indexPath: IndexPath) {
        let hotelToDelete = viewModel.hotels[indexPath.row]
        
        viewModel.deleteHotel(hotelToDelete, for: self.trip) { isSuccessful in
            if isSuccessful {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                self.presentAlert(error: nil, title: "Deleting a Hotel")
            }
        }
    }
    
    private func editHotel(at indexPath: IndexPath) {
        let hotelToEdit = viewModel.hotels[indexPath.row]
        
        let editHotelAlert = UIAlertController(
            hotelEditorFor: self.trip,
            hotelName: hotelToEdit.name,
            hotelAddress: hotelToEdit.address) { [unowned self] hotelName, hotelAddress in
            
            self.viewModel.updateHotel(hotelToEdit, for: self.trip) { isSuccessful in
                if isSuccessful {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    self.presentAlert(error: nil, title: "Updating a Hotel")
                }
            }
        }
        self.present(editHotelAlert, animated: true)
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func pressAddHotel(_ sender: Any) {
        
        let newHotelAlert = UIAlertController(hotelEditorFor: self.trip) { [unowned self] hotelName, hotelAddress in
            
            self.viewModel.createHotel(name: hotelName, address: hotelAddress, for: self.trip) { isSuccessful in
                if isSuccessful {
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
        
        viewModel.fetchHotels(for: self.trip) { [weak self] isSuccessful in
            guard let unwrappedSelf = self else { return }
            
            if isSuccessful {
                unwrappedSelf.tableView.reloadData()
            } else {
                unwrappedSelf.presentAlert(error: nil, title: "Loading Hotels")
            }
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (action, indexPath) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.editHotel(at: indexPath)
        }
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.deleteHotel(at: indexPath)
        }
        
        return [deleteAction, editAction]
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
