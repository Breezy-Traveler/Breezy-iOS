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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let userPersistence = UserPersistence()
//        userPersistence.logoutUser()
//        
//        // Override point for customization after application launch.
//        // TODO: Remove when done testing
//        let netStack = NetworkStack()
//
//        let newTrip = BTTrip(place: "New PLace!!!", isPublic: false)
//        netStack.createTrip(trip: newTrip) { (result) in
//            switch result {
//            case .success(let returnedTrip):
//                print("Successfully created trip: \(returnedTrip.place)")
//
//                // Add a Hotel for the added trip
//                let newHotel = BTHotel(title: "Days Inn, yo!", visited: false)
//                let dg = DispatchGroup()
//                dg.enter()
//                var returnedHotel: BTHotel? = nil
//                print("#### creating hotel")
//                netStack.create(a: newHotel, for: returnedTrip, completion: { (result) in
//                    switch result {
//                    case .success(let returnedHotelValue):
//                        returnedHotel = returnedHotelValue
//                        print("Successfully created hotel, \(returnedHotel!.title), for the \(returnedTrip.place) trip")
//                        
//                    case .failure(let errors):
//                        print("Failed! \(errors)")
//                    }
//                    print("#### done (creating hotel)")
//                    dg.leave()
//                })
//                
//                // update added hotel
//                dg.notify(queue: .main, execute: {
//                    let dg = DispatchGroup()
//                    print("#### updating hotel \(returnedHotel!)")
//                    dg.enter()
//                    returnedHotel!.address = "1234 California St"
//                    netStack.update(hotel: returnedHotel!, for: returnedTrip, completion: { (result) in
//                        switch result {
//                        case .success(let returnedHotelValue):
//                            returnedHotel = returnedHotelValue
//                            print("Successfully updated hotel, \(returnedHotel!.title), to \(returnedHotelValue)")
//                            
//                        case .failure(let errors):
//                            print("Failed! \(errors)")
//                        }
//                        print("#### done (updating hotel)")
//                        dg.leave()
//                    })
//                    
//                    dg.notify(queue: .main, execute: {
//                        print("#### showing hotel with id = \(returnedHotel!.id)")
//                        let dg = DispatchGroup()
//                        dg.enter()
//                        netStack.showHotel(for: returnedHotel!.id, for: returnedTrip, completion: { (result) in
//                            switch result {
//                            case .success(let returnedHotelValue):
//                                print("Successfully fetched hotel: \(returnedHotelValue)")
//                            case .failure(let errors):
//                                print("Failed! \(errors)")
//                            }
//                            print("#### done (showing hotel)")
//                            dg.leave()
//                        })
//                        
//                        // Delete hotel
//                        dg.notify(queue: .main, execute: {
//                            print("#### delete hotel \(returnedHotel!)")
//                            netStack.delete(hotel: returnedHotel!, for: returnedTrip, completion: { (result) in
//                                switch result {
//                                case .success(let message):
//                                    print("Successfully deleted hotel, \(message)")
//                                    
//                                case .failure(let errors):
//                                    print("Failed! \(errors)")
//                                }
//                                print("#### done (delete hotel)")
//                            })
//                        })
//                    })
//                })
//                
//                // Remove that added Hotel for the added trip
//                
//
//            case .failure(let errors):
//                print("Failed! \(errors)")
//            }
//        }
        
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

