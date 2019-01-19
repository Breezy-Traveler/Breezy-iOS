//
//  AppDelegate.swift
//  Breezy-Traveler
//
//  Created by Phyllis Wong on 3/26/18.
//  Copyright © 2018 Breezy Traveler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let loginMiddleware = LoginLayer.instance
    
    var alertWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set the navigation bar appearence for the entire app
        let navigationBarAppearance = UINavigationBar.appearance()

        // Change navigation item title color for the whole app
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]

        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        let tripsStoryboard = UIStoryboard(name: "Trips", bundle: nil)
        guard let tripsVc = tripsStoryboard.instantiateInitialViewController() else {
            fatalError("storyboard not set up with an initial view controller")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tripsVc
        window?.makeKeyAndVisible()
        
        loginMiddleware.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIWindow {
    static var applicationAlertWindow: UIWindow {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("something is definantly wrong if app delegate is not AppDelegate")
        }
        
        let alertWindow: UIWindow
        if let window = appDelegate.alertWindow {
            alertWindow = window
        } else {
            
            guard let appDelegateWindow = appDelegate.window else {
                fatalError("requires the app delegate to have a window")
            }
            
            alertWindow = UIWindow(frame: appDelegateWindow.bounds)
            appDelegate.alertWindow = alertWindow
            alertWindow.windowLevel = UIWindowLevelAlert + 1
        }
        
        return alertWindow
    }
}

extension AppDelegate: LoginLayerDelegate {
    
    func userNeedsToLogin(_ loginLayer: LoginLayer) {
        guard let appWindow = self.window else {
            fatalError("window not set up")
        }
        
        throttle(for: 5) {
            let loginVc = LoginController()
            
            appWindow.set(rootViewController: loginVc)
            loginVc.presentAlert(error: "please login")
        }
    }
}

extension UIWindow {
    
    /// From https://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview/27153956
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}

