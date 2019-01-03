//
//  LoadingViewController.swift
//  Breezy-Traveler
//
//  Created by Erick Sanchez on 1/2/19.
//  Copyright © 2019 Phyllis Wong. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: - VARS
    
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func present() {
        let window = UIWindow.applicationAlertWindow
        
        view.alpha = 0
        
        //if the loading is shown for less than 0.25 seconds, the user will not see the loading indicator
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { [weak self] _ in
            window.rootViewController = self
            
            guard let unwrappedSelf = self else { return }
            
            UIView.animate(withDuration: 0.15, animations: {
                unwrappedSelf.view.alpha = 1
            })
        }
        window.makeKey()
        window.isHidden = false
    }
    
    func dismiss(completion: @escaping () -> Void) {
        let window = UIWindow.applicationAlertWindow
        
        window.isHidden = true
        guard let appWindow = UIApplication.shared.delegate!.window! else {
            return completion()
        }
        
        UIWindow.applicationAlertWindow.rootViewController = nil
        appWindow.makeKey()
        completion()
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indicator = self.loadingIndicator {
            indicator.startAnimating()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let indicator = self.loadingIndicator {
            indicator.stopAnimating()
        }
    }
}
