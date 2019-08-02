//
//  ViewControllerPopover.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 02/08/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit

class Popover {
    var title : String!
    var detail : String!
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}

class ViewControllerPopover: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var tableView: UITableView!
    
    var time = ""
    var releaseDate = ""
    
    var popoverArray = [Popover]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let array = Popover(title: "Дата скачивания:", detail: time)
        let array1 = Popover(title: "Дата релиза песни:", detail: releaseDate)
        popoverArray.append(array)
        popoverArray.append(array1)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popoverArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let array = popoverArray[indexPath.row]

        cell.textLabel?.text = array.title
        cell.textLabel?.font = UIFont(name:"OpenSans-Semibold", size: 17.0)
        cell.detailTextLabel?.text = array.detail
        cell.detailTextLabel?.font = UIFont(name:"OpenSans-Semibold", size: 17.0)

        return cell
    }
  

}
