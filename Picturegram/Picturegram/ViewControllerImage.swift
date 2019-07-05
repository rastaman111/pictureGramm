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
    
        imageDetail.downloadImage(from: imageName)
        
    }
    
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        AlertDialog.showAlert("Дата скачивания:", message: "\(time)", viewController: self)
    }
    
    deinit {
        print("ViewControllerImage deinit")
    }
    
}


extension UIImageView {
    
    func downloadImage(from url: String) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
            
        }).resume()
    }
    
}
