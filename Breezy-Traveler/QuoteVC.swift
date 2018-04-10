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

class QuoteVC: UIViewController {
    
    // Instance of networking stack
    let networkStack = NetworkStack()
    let userPersistence = UserPersistence()
    
    @IBOutlet weak var quoteOfTheDayLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkStack.getQuoteOfTheDay { (quoteModel) in
            DispatchQueue.main.async {
                self.quoteOfTheDayLabel.text = quoteModel.quote
                self.authorLabel.text = "Author - \(quoteModel.author)"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userPersistence.checkUserLoggedIn { (isLoggedIn) in
            if !isLoggedIn {
                let loginViewController = LoginController()
                self.present(loginViewController, animated: false, completion: nil)
//                self.performSegue(withIdentifier: "loginControllerSegue", sender: nil)
            }
        }
    }
    
    @IBAction func pressedLogout(_ sender: UIBarButtonItem) {
        let userPersistence = UserPersistence()
        userPersistence.logoutUser()
        let loginViewController = LoginController()
        self.present(loginViewController, animated: false, completion: nil)
    }
}

