//
//  ApplicationService.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 1/18/19.
//  Copyright © 2019 Phyllis Wong. All rights reserved.
//

import SafariServices

struct ApplicationService {
    static func openGettingStarted(presentor: UIViewController) {
        let url = URL(string: "https://medium.com/@wong.phyllism/get-started-with-breezy-traveler-app-8b803d87cf64")!
        
        let safariVc = SFSafariViewController(url: url)
        presentor.present(safariVc, animated: true)
    }
}
