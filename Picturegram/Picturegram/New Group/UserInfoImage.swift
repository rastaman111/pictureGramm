//
//  UserInfoImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 05/07/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import Foundation
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

class UserInfoImage: NSObject {
    
    static let urlString = "https://rss.itunes.apple.com/api/v1/ru/apple-music/top-songs/all/10/explicit.json"
    
    static func forecast(completion: @escaping ([UserImage]) -> ()) {

        guard let url = URL(string: urlString) else {return}
        
         URLSession.shared.dataTask(with: url) { (data, response, error) in
        
                 if let data = data {
        
                    var listItems = [NSManagedObject]()
                    
                    var array: [UserImage] = []
                    
                    let date = Date()
                    
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        
                        if let feed = jsonArray["feed"] as? [String: AnyObject] {
                            if let results = feed["results"] as? NSArray {
                                
                               
                                listItems.removeAll()
                                try PersistenceServce.contex.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Item")))
                                
                                for i in results {
                                    if let artworkUrlArray = i as? [String: AnyObject] {
                                        
                                        let artworkUrl = artworkUrlArray["artworkUrl100"] as! String
                                        let artistName = artworkUrlArray["artistName"] as! String
                                        let soundName = artworkUrlArray["name"] as! String
                                        
                                        let arrayT = UserImage(image: artworkUrl, artist: artistName, sound: soundName)
                                        array.append(arrayT)
                                        
                                        let item = Item(context: PersistenceServce.contex)
                                        item.artist = artistName
                                        item.sound = soundName
                                        item.image = artworkUrl
                                        
                                        let DF = DateFormatter()
                                        DF.dateFormat = "d MMM yyyy, HH:mm"
                                        DF.locale = Locale(identifier: "ru_RU")
                                        let dd = DF.string(from: date)
                                        item.date = dd
                                        
                                        do {
                                            try PersistenceServce.contex.save()
                                            listItems.append(item)
                                        } catch {
                                            print("Didn't Save")
                                        }
                                        
                                    }
                                    
                                }
                            
                            }
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    completion(array)
            }
        }.resume()
    }
}
