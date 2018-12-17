//
//  ResourceViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 12/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit

protocol Resource {
    var id: String { get }
    var name: String { get set }
    var address: String { get set }
}

protocol ResourceViewModel {
    
    var resource: [Resource] { get }
    var resourceName: String { get }
    
    func fetchResource(for trip: Trip, completion: @escaping (Bool) -> Void)
    func createResource(name: String, address: String, for trip: Trip, completion: @escaping (Bool) -> Void)
    func updateResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void)
    func deleteResource(_ resource: Resource, for trip: Trip, completion: @escaping (Bool) -> Void)
}

/**
 Abstract Class. You must inherit and provide a viewModel (perfabily in viewDidLoad)
 */
class ResourceViewController: UIViewController {
    
    // MARK: - VARS
    
    var trip: Trip!
    
    var viewModel: ResourceViewModel!
    
    private var resource: [Resource] {
        return viewModel.resource
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    private func deleteResource(at indexPath: IndexPath) {
        let resourceToDelete = viewModel.resource[indexPath.row]
        
        viewModel.deleteResource(resourceToDelete, for: self.trip) { [weak self] isSuccessful in
            guard let unwrappedSelf = self else { return }
            
            if isSuccessful {
                unwrappedSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                unwrappedSelf.presentAlert(error: nil, title: "Deleting a \(unwrappedSelf.viewModel.resourceName)")
            }
        }
    }
    
    private func editResource(at indexPath: IndexPath) {
        var resourceToEdit = viewModel.resource[indexPath.row]
        
        let editorAlert = UIAlertController(
            editorTitle: viewModel.resourceName,
            trip: self.trip,
            name: resourceToEdit.name,
            address: resourceToEdit.address) { [unowned self] name, address in
                
                resourceToEdit.name = name
                resourceToEdit.address = address
                self.viewModel.updateResource(resourceToEdit, for: self.trip) { [weak self] isSuccessful in
                    guard let unwrappedSelf = self else { return }
                    
                    if isSuccessful {
                        unwrappedSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
                    } else {
                        unwrappedSelf.presentAlert(error: nil, title: "Updating a \(unwrappedSelf.viewModel.resourceName)")
                    }
                }
        }
        self.present(editorAlert, animated: true)
    }
    
    override func loadView() {
        guard let viewFromNib = Bundle.main.loadNibNamed("ResourceView", owner: self, options: nil)?.first as? UIView else {
            fatalError("xib file not set up correctly")
        }

        view = viewFromNib
    }
    
    // MARK: - IBACTIONS
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func pressAddResource(_ sender: Any) {
        
        let newResourceAlert = UIAlertController(editorTitle: viewModel.resourceName, trip: self.trip) { [unowned self] name, address in
            
            self.viewModel.createResource(name: name, address: address, for: self.trip) { [weak self] isSuccessful in
                guard let unwrappedSelf = self else { return }
                
                if isSuccessful {
                    unwrappedSelf.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                } else {
                    unwrappedSelf.presentAlert(error: nil, title: "Adding a \(unwrappedSelf.viewModel.resourceName)")
                }
            }
        }
        self.present(newResourceAlert, animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //setup view controller
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.pressAddResource(_:))
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.resourceName.plural
        
        viewModel.fetchResource(for: self.trip) { [weak self] isSuccessful in
            guard let unwrappedSelf = self else { return }
            
            if isSuccessful {
                unwrappedSelf.tableView.reloadData()
            } else {
                unwrappedSelf.presentAlert(error: nil, title: "Loading \(unwrappedSelf.viewModel.resourceName)")
            }
        }
    }
}

extension ResourceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.trip.place.isNotEmpty else {
            return nil
        }
        
        return "\(viewModel.resourceName.plural) for \(self.trip.place)"
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (action, indexPath) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.editResource(at: indexPath)
        }
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.deleteResource(at: indexPath)
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResourceTVCell
        
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "resource cell") as! ResourceTVCell? {
            cell = dequeueCell
        } else {
            cell = ResourceTVCell(style: .subtitle, reuseIdentifier: "resource cell")
        }
        
        let resource = self.resource[indexPath.row]
        cell.configure(resource)
        
        return cell
    }
}
