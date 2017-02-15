//
//  AppDelegate.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let _ = FIRAuth.auth()?.currentUser {
            self.window?.rootViewController = finalInstagramTabBarController()
        } else {
            self.window?.rootViewController = LoginViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
        if self.window!.rootViewController as? UITabBarController != nil {
            let tababarController = self.window!.rootViewController as! UITabBarController
            if FIRAuth.auth()?.currentUser == nil {
                tababarController.selectedIndex = 2
            }
        }

        
        return true
    }
    
    
    func finalInstagramTabBarController() -> UITabBarController {
        let uploadViewController = UploadViewController()
        let feedViewController = FeedViewController()
        
        let feedImage = UIImage(named: "chickenleg")
        let feedIcon = UITabBarItem(title: "Feed", image: UIImage(named: "chickenleg"), selectedImage: UIImage(named: "chickenleg"))
        //TO DO FIX IMAGE SIZE ON BOTH
        feedViewController.tabBarItem = feedIcon
        
        let uploadIcon = UITabBarItem(title: "Upload", image: UIImage(named: "upload"), selectedImage: UIImage(named: "upload"))
        uploadViewController.tabBarItem = uploadIcon
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [UINavigationController(rootViewController: feedViewController), UINavigationController(rootViewController: uploadViewController)]
        
        return tabBarController
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

