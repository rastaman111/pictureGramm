//
//  ViewController.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reachabilityIconView: UIView!
    @IBOutlet weak var loadTableViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadTableViewLabel: UILabel!
    
    @IBOutlet weak var buildVersionLabel: UILabel!
    
    var array: [UserImage] = []
    
    var listItems = [NSManagedObject]()
    
    let date = Date()
    
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        loadTableViewIndicator.startAnimating()
        
        title = "Picturegram"
        
        buildVersionLabel.text = getVersion()
        
        UserInfoImage.forecast { (results: [UserImage]) in
            for i in results {
                
                let arrayT = UserImage(image: i.image, artist: i.artist, sound: i.sound, urlMusic: i.urlMusic)
                self.array.append(arrayT)
                
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.loadTableViewLabel.isHidden = true
                    self.loadTableViewIndicator.stopAnimating()
                    self.loadTableViewIndicator.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
        
        tableView.bounces = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let result = try PersistenceServce.contex.fetch(fetchRequest)
            listItems = result as [NSManagedObject]
            self.tableView.reloadData()
        }catch{
            print("Data didn not Retrieve")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: nil)
        
        updateUserInterface()

    }
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        let build = dictionary[kBuildNumber] as! String
        
        return "Версия \(version), сборка \(build)"
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            //view.backgroundColor = .red
            reachabilityIconView.isHidden = false
        case .wwan:
            reachabilityIconView.isHidden = true
        case .wifi:
            reachabilityIconView.isHidden = true
        }
//        print("Reachability Summary")
//        print("Status:", Network.reachability.status)
//        print("HostName:", Network.reachability.hostname ?? "nil")
//        print("Reachable:", Network.reachability.isReachable)
//        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 385
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch Network.reachability.status {
        case .unreachable:
            return listItems.count
        case .wwan, .wifi:
            return array.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        
       switch Network.reachability.status {
       case .unreachable:
            let item = listItems[indexPath.row] as! Item
    
            cell.imageViewCell.downloadImage(from: (item.image!))
            cell.artistNameCell.text = item.artist
            cell.soundNameCell.text = item.sound
            cell.topLabel.text = "Топ \(indexPath.row + 1)"
            cell.spinner.isHidden = true
       case .wwan, .wifi:
        
            if let tweetCell = cell as? TableViewCell {
                tweetCell.imageURL = URL(string: self.array[indexPath.row].image)
            }
            
            cell.artistNameCell.text = array[indexPath.row].artist
            cell.soundNameCell.text = array[indexPath.row].sound
            cell.topLabel.text = "Топ \(indexPath.row + 1)"

        }
        
        cell.selectionStyle = .none

        return cell
    }
    

    
//
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! TableViewCell).spinner.stopAnimating()
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {

                let detailVC = segue.destination as! ViewControllerImage
                
                switch Network.reachability.status {
                case .unreachable:
                    let item = listItems[indexPath.row] as! Item
                    
                    detailVC.imageName = item.image!
                    detailVC.title = item.artist
                    detailVC.time = item.date!
                    detailVC.urlMusic = item.urlMusic!
                    detailVC.songName = item.sound!
                    
                case .wwan, .wifi:
                    detailVC.imageName = array[indexPath.row].image
                    detailVC.title = array[indexPath.row].artist
                    detailVC.songName = array[indexPath.row].sound
                    
                    let DF = DateFormatter()
                    DF.dateFormat = "d MMM yyyy, HH:mm"
                    DF.locale = Locale(identifier: "ru_RU")
                    let dd = DF.string(from: date)
                    detailVC.time = dd
                    detailVC.urlMusic = array[indexPath.row].urlMusic
                }

            }
        }
    }

}



