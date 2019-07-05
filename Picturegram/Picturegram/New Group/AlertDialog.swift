//
//  File.swift
//  fireBaseMokr
//
//  Created by Александр Сибирцев on 28/01/2019.
//  Copyright © 2019 Alexandr Sibirtsev. All rights reserved.
//

import Foundation
import UIKit

class AlertDialog {
    
    class func showAlert(_ title: String, message: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}

