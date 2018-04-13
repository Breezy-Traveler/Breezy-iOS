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
    
    @IBOutlet weak var quoteOfTheDayLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userPersistence.checkUserLoggedIn { (isLoggedIn) in
            if !isLoggedIn {
                let loginViewController = LoginController()
                self.present(loginViewController, animated: false, completion: nil)
            } else {
                self.networkStack.getQuoteOfTheDay { (quoteModel) in
                    DispatchQueue.main.async {
                        
                        // FIXME: Just for testing how the text looks on the screen
                        let dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
                        
                                        self.quoteOfTheDayLabel.text = dummyText
                        
                        // Uncomment this line after testing
//                        self.quoteOfTheDayLabel.text = quoteModel.quote
                        self.authorLabel.text = "Author - \(quoteModel.author)"
                    }
                }
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

