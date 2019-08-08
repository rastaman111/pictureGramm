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
    
    var kTableHeaderHeight:CGFloat = 250.0
    var headerView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight + 5)
        updateHeaderView()
        
        
        self.tableView.isHidden = true
        loadTableViewIndicator.startAnimating()
        
        title = "Picturegram"
        
        buildVersionLabel.text = getVersion()
        
        UserInfoImage.forecast { (results: [UserImage]) in
            for i in results {
                
                let arrayT = UserImage(id: i.id, image: i.image, artist: i.artist, sound: i.sound, urlMusic: i.urlMusic, releaseDate: i.releaseDate)
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
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        
//        let content = scrollView.contentOffset.y
//        print(content)
        
    }
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            tableView.isHidden = false
            reachabilityIconView.isHidden = false
        case .wwan:
            reachabilityIconView.isHidden = true
        case .wifi:
            reachabilityIconView.isHidden = true
        }
//        print("Reachability Summary")
//        print("Status:", Network.reachViewController
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
        
            let arrayCell = array[indexPath.row]
            
            cell.artistNameCell.text = arrayCell.artist
            cell.soundNameCell.text = arrayCell.sound
            cell.topLabel.text = "Топ \(indexPath.row + 1)"
        
            if let tweetCell = cell as? TableViewCell {
                tweetCell.imageURL = URL(string: arrayCell.image)
            }
        
        }
        cell.indentationLevel = 2
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! TableViewCell).spinner.stopAnimating()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {

                let detailVC = segue.destination as! ViewControllerImage
                
                switch Network.reachability.status {
                case .unreachable:
                    let item = listItems[indexPath.row] as! Item
                    
                    detailVC.imageName = item.image!
                    detailVC.artistName = item.artist!
                    detailVC.title = item.artist
                    detailVC.time = item.date!
                    detailVC.urlMusic = item.urlMusic!
                    detailVC.songName = item.sound!
                    detailVC.releaseDate = item.releaseDate!
                    detailVC.connected = false
                    
                case .wwan, .wifi:
                    let arrayPrepare = array[indexPath.row]
                    
                    detailVC.imageName = arrayPrepare.image
                    detailVC.title = arrayPrepare.artist
                    detailVC.artistName = arrayPrepare.artist
                    detailVC.songName = arrayPrepare.sound
                    detailVC.urlMusic = arrayPrepare.urlMusic
                    detailVC.releaseDate = arrayPrepare.releaseDate
                    detailVC.id = arrayPrepare.id
                    detailVC.connected = true
                    
                    let DF = DateFormatter()
                    DF.dateFormat = "d MMM yyyy, HH:mm"
                    DF.locale = Locale(identifier: "ru_RU")
                    let dd = DF.string(from: date)
                    detailVC.time = dd
                    
                }

            }
        }
    }

}



