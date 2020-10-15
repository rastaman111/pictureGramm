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
        let backButtonImage = UIImage(named: "back")
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = #colorLiteral(red: 0.4395738244, green: 0.3904562891, blue: 0.8513493538, alpha: 1)
        navBar.tintColor = UIColor.white
        navBar.barStyle = .black
        
        navBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            //NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 19)!
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

