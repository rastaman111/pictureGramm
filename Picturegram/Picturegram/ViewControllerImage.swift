//
//  ViewControllerImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit

class ViewControllerImage: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var nameSong: UILabel!
    
    var imageName = ""
    var time = ""
    var songName = ""
    var urlMusic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageDetail.downloadImage(from: imageName)
        imageDetail.layer.cornerRadius = 10
        imageDetail.layer.masksToBounds = true

        
        nameSong.text = songName
        nameSong.textColor = UIColor(red: 0.4, green: 0.47, blue: 0.6, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func dateButton(_ sender: UIButton) {
         AlertDialog.showAlert("Дата скачивания:", message: "\(time)", viewController: self)
    }
   
    @IBAction func openMusic(_ sender: UIButton) {
        open(scheme: urlMusic)
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    
                    if success != true {
                       AlertDialog.showAlert("Ошибка", message: "Повторите запрос позже или ссылка не работает.", viewController: self)
                    }
                    
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
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
