//
//  ViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift

class QuoteViewController: UIViewController {
    
    // Instance of networking stack
    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    var quote: Quote? = nil
    
    @IBOutlet weak var quoteOfTheDayLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Breezy Traveler"
        setupNavigationBarAppearence()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // FIXME: App Crashes due to too many calls to the QOD
        // self.networkStack.getQuoteOfTheDay { (quoteModel) in
            // DispatchQueue.main.async {
                // Uncomment this line after testing
                // self.quoteOfTheDayLabel.text = quoteModel.quote
                // self.authorLabel.text = "Author - \(quoteModel.author)"
            // }
        // }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userPersistence.checkUserLoggedIn { [weak self] (isLoggedIn) in
            guard let unwrappedSelf = self else { return }
            
            if !isLoggedIn {
                let loginViewController = LoginController()
                unwrappedSelf.present(loginViewController, animated: false, completion: nil)
            }
        }
        
        let dummyText = "We must let go of the life we have planned, so as to accept the one that is waiting for us."
        
        self.quoteOfTheDayLabel.text = dummyText
        self.authorLabel.text = "Author - Joseph Campbell"
    }
    
    @IBAction func pressedLogout(_ sender: UIBarButtonItem) {
        var userPersistence = UserPersistence()
        userPersistence.logoutUser()
        let loginViewController = LoginController()
        self.present(loginViewController, animated: false, completion: nil)
    }
}

