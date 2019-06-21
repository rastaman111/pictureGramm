//
//  ViewController.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit
import CoreData

class UserImage {
   
    
    var image: String!
    var artist: String!
    var sound: String!
    
    init(image: String, artist: String, sound: String) {
        self.image = image
        self.artist = artist
        self.sound = sound
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var array: [UserImage] = []
    
    let defaults = UserDefaults.standard
    
    var listItems = [NSManagedObject]()
    
    let date = Date()
    
    let urlString = "https://rss.itunes.apple.com/api/v1/ru/apple-music/top-songs/all/10/explicit.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let result = try PersistenceServce.contex.fetch(fetchRequest)
            listItems = result as [NSManagedObject]
            self.tableView.reloadData()
        }catch{
            print("Data didn not Retrieve")
        }
        
        
        title = "Picturegram"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                
                if let feed = jsonArray["feed"] as? [String: AnyObject] {
                    if let results = feed["results"] as? NSArray {
                        
                        self.listItems.removeAll()
                        try PersistenceServce.contex.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Item")))
                     
                        for i in results {
                            if let artworkUrlArray = i as? [String: AnyObject] {
                                
                                let artworkUrl = artworkUrlArray["artworkUrl100"] as! String
                                let artistName = artworkUrlArray["artistName"] as! String
                                let soundName = artworkUrlArray["name"] as! String
                                
                                let arrayT = UserImage(image: artworkUrl, artist: artistName, sound: soundName)
                                self.array.append(arrayT)
                                
                                let item = Item(context: PersistenceServce.contex)
                                item.artist = artistName
                                item.sound = soundName
                                item.image = artworkUrl
                                
                                let DF = DateFormatter()
                                DF.dateFormat = "dd-MMMM-yyyy HH:mm"
                                let dd = DF.string(from: self.date)
                                item.date = dd
                                
                                do {
                                    try PersistenceServce.contex.save()
                                    self.listItems.append(item)
                                } catch {
                                    print("Didn't Save")
                                }
                                
                            }
                           
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            }
        }.resume()
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 385
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count == 0 {
            print("Not connect")
            return listItems.count
        }else{
            print("Sucsess")
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if array.count == 0 {
            let item = listItems[indexPath.row] as! Item
            
            cell.artistNameCell.text = item.artist
            cell.soundNameCell.text = item.sound
            cell.imageViewCell.loadImageUsingCacheWithUrlString(item.image!)
            cell.topLabel.text = "Топ \(indexPath.row + 1)"
        }else{
            
            cell.imageViewCell.loadImageUsingCacheWithUrlString(self.array[indexPath.row].image)
            cell.artistNameCell.text = array[indexPath.row].artist
            cell.soundNameCell.text = array[indexPath.row].sound
            cell.topLabel.text = "Топ \(indexPath.row + 1)"
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {

                let detailVC = segue.destination as! ViewControllerImage

                if array.count == 0 {
                    let item = listItems[indexPath.row] as! Item

                    detailVC.imageName = item.image!
                    detailVC.title = item.artist
                    detailVC.time = item.date!
                    
                }else{
                    detailVC.imageName = array[indexPath.row].image
                    detailVC.title = array[indexPath.row].artist
                    
                    let DF = DateFormatter()
                    DF.dateFormat = "dd-MMMM-yyyy HH:mm"
                    let dd = DF.string(from: date)
                    detailVC.time = dd
                }
            }
        }
    }

}

