//
//  AppDelegate.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {

        }
        
        let backButtonImage = UIImage(named: "back")
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor(red: 0.4, green: 0.47, blue: 0.68, alpha: 1)
        navBar.tintColor = UIColor.white
        navBar.barStyle = .black
        
        navBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 18)!
        ]
        
        navBar.backIndicatorImage = backButtonImage
        navBar.backIndicatorTransitionMaskImage = backButtonImage
        
        let barButton = UIBarButtonItem.appearance()
        barButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        barButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -220, vertical: 0), for: .default)
        
        return true
    }
    
    func application(_ applicaton: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }

   
}

