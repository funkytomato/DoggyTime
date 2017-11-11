//
//  AppDelegate.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 20/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate let coreDataManager = CoreDataManager(modelName: "DoggyTimev2")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        _ = coreDataManager.mainManagedObjectContext
        
        if let tab = window?.rootViewController as? UITabBarController
        {
            for child in tab.viewControllers ?? []
            {

            /*
                guard let navigationController = window?.rootViewController as? UINavigationController,
                    let clientsViewController = navigationController.topViewController as? ClientsViewController else {
                        fatalError("Application Storyboard mis-configuration") }
                
                 clientsViewController.coreDataManager = coreDataManager
              */
                


                
                if let child = child as? UINavigationController, let top = child.topViewController
                {
                    
                    //if ((top as? CoreDataManagerDelegate) != nil)
                    if let mydelegate = top as? CoreDataManagerDelegate
                    {
                        print("Client conforms!!!")
                        mydelegate.setCoreDataManager(coreDataManager: coreDataManager)
                        
                    }
                    else
                    {
                        print("not conforming!!!")
                    }
            
                    
                    
                    /*
                    if child.conforms(to: CoreDataManagerDelegate)
                    {
                        print("Child conforms to CoreDataManagerDelegate")
                    }
                    
                    if top.conforms(to: CoreDataManagerDelegate)
                    {
                        print("Top conforms to CoreDataManagerDelegate")
                    }
                     */
                }
                
                
            
                /*
                if ([segue.destinationViewController isKindOfClass:[GoalDetailsViewController class]])
                {
                    GoalDetailsViewController *goalsDetailsViewController = segue.destinationViewController;
                    goalsDetailsViewController.goalName = @"Exercise Daily";
                }
                */
                
            }
        }
        
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

