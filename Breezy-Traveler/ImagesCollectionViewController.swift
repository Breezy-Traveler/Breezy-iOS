//
//  ImagesCollectionViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
//import kingfisher

class ImagesCollectionViewController: UICollectionViewController {
    
    var networkStack = NetworkStack()
    var searchTerm: String!
    private var fetchedImagesUrls = [URL]()
    
    private let reuseIdentifier = ImagesCollectionViewCell.reuseIdentifier

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let cellNib = UINib(nibName: "ImagesCollectionViewCell", bundle: Bundle.main)
        
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: self.reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkStack.fetchImages(searchTerm: self.searchTerm) { (urls) in
            fetchedImagesUrls
        }
        
        collectionView?.reloadData()
    }



    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 100
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = #imageLiteral(resourceName: "destination_carousel_berlin")
    
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100.0, height: 100.0)
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
