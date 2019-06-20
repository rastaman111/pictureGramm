//
//  ViewControllerImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit



//Все задания выполнены
//Одна только проблема, когда нет интернета(режим оффлайн) данные даты из CoreData не передаются на другой контроллер и поэтому происходит крах приложения
//
//
//


class ViewControllerImage: UIViewController {

    @IBOutlet weak var imageDetail: UIImageView!
    
    var imageName = ""
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetail.loadImageUsingCacheWithUrlString(imageName)
        
    }
    
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        let DF = DateFormatter()
        DF.dateFormat = "dd-MMMM-yyyy HH:mm"
        let dd = DF.string(from: date)
        
        AlertDialog.showAlert("Дата скачивания:", message: "\(dd)", viewController: self)
    }
    
   

}
