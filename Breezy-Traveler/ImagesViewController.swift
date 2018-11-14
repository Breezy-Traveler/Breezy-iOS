//
//  ImagesCollectionViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 4/6/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Kingfisher

protocol CoverImagePickerDelegate: class {
    func imageView(_ imageViewController: ImagesViewController, didSetImage imageUrl: URL)
}

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkStack = NetworkStack()
    var searchTerm: String!
    private let padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    
    // Create an instance of CoverImagePickerDelegate
    weak var coverImagePickerDelegate: CoverImagePickerDelegate?
    
    private var fetchedImagesUrls = [URL]() {
        didSet {
            collectionView!.reloadData()
        }
    }
    
    private let reuseIdentifier = ImagesCollectionViewCell.reuseIdentifier

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let cellNib = UINib(nibName: "ImagesCollectionViewCell", bundle: Bundle.main)
        
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: self.reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkStack.fetchImages(searchTerm: self.searchTerm) { (result) in
            switch result {
            case .success(let urls):
                if urls.count > 0 {
                    self.fetchedImagesUrls = urls
                } else {
                    UIAlertController(title: "Cover Image", message: "no results found for \"\(self.searchTerm)\"", preferredStyle: .alert)
                        .addDismissButton()
                        .present(in: self)
                }
                
            case .failure(let userErrors):
                let alert = AlertViewController.showErrorAlert(message: userErrors.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width) - (padding.left + padding.right)
        let height = (view.frame.height) / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedImagesUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
        
        let url = fetchedImagesUrls[indexPath.row]
        // Configure the cell
        cell.imageView.kf.setImage(with: url)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped image")
        
        let pickedImageUrl = fetchedImagesUrls[indexPath.row]
        
        // pass the image back to TripDetailView
        coverImagePickerDelegate?.imageView(self, didSetImage: pickedImageUrl)
        
        navigationController?.popViewController(animated: true)
    }

     // Uncomment this method to specify if the specified item should be highlighted during tracking
//     func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//     return true
//     }

     // Uncomment this method to specify if the specified item should be selected
//     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//     return true
//     }

    
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
