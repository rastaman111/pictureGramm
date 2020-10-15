//
//  ReachabilityManager.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 14.10.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: ReachabilityManager = { return ReachabilityManager() }()
    
    override init() {
        super.init()
        
        reachability = try! Reachability()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            try (ReachabilityManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isReachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection != .unavailable {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .unavailable {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .cellular {
            completed(ReachabilityManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .wifi {
            completed(ReachabilityManager.sharedInstance)
        }
    }
}

