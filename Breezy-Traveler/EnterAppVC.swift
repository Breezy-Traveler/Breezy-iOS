//
//  ViewController.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Phyllis Wong. All rights reserved.
//

import UIKit
import Moya

class EnterAppVC: UIViewController {
    
    let networkStack = NetworkStack()
    @IBOutlet weak var quoteOfTheDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkStack.getQuoteOfTheDay { (quoteModel) in
            DispatchQueue.main.async {
                self.quoteOfTheDayLabel.text = quoteModel.quote
            }
//            print(quoteModel.quote)
        }

    }
}

// 1: All the end points for HTTP request
enum QODAPIEndPoint {
    case getQuote
}

// 2: Conforms and implements Target Type (Moya specific protocol)
extension QODAPIEndPoint: TargetType {

    // 3: Base URL leads to no end point
    var baseURL: URL { return URL(string: "https://quotes.rest/qod.json")! }
    
    var path: String {
        switch self {
        case .getQuote:
            return ""

        }
    }

    // 5: HTTP Method
    var method: Moya.Method {
        switch self {
        case .getQuote:
            return .get
        }
    }
    
    // 6: Test the data in Swift
    // MARK: Todo later
    var sampleData: Data {
        return Data()
    }
    
    // 7: Body + params and any attachments
    var task: Task {
        switch self {
        case .getQuote:
            return .requestPlain
        }
    }
    
    // 8: Include the header as the last bit of the request
    // Sample token for testing: "token": "a0a5304ef3a7ec90deb874a1dd3e4812"
    
    var headers: [String : String]? {
        let defaultHeader = [String : String]()
        switch self {
        case .getQuote:
            return defaultHeader
        }
    }
}

