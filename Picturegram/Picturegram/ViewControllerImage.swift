//
//  ViewControllerImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit

class ViewControllerImage: UIViewController {

    @IBOutlet weak var imageDetail: UIImageView!
    
    var imageName = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageDetail.loadImageUsingCacheWithUrlString(imageName)
        
    }
    
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        AlertDialog.showAlert("Дата скачивания:", message: "\(time)", viewController: self)
    }
    
}
