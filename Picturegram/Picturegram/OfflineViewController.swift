//
//  OfflineViewController.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 15.10.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    
    let network = ReachabilityManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenReachable = { reachability in
            self.showMainController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setTabBarHidden(true, animated: animated, duration: 0.3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setTabBarHidden(false, animated: animated, duration: 0.3)
    }
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
}

extension UIViewController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
}


