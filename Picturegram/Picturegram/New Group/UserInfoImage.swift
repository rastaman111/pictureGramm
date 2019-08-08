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
    
    var id: String!
    var image: String!
    var artist: String!
    var sound: String!
    var urlMusic: String!
    var releaseDate: String!
    
    init(id: String, image: String, artist: String, sound: String, urlMusic: String, releaseDate: String! ) {
        self.id = id
        self.image = image
        self.artist = artist
        self.sound = sound
        self.urlMusic = urlMusic
        self.releaseDate = releaseDate
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
                                        let urlMusic = artworkUrlArray["url"] as! String
                                        let releaseDate = artworkUrlArray["releaseDate"] as! String
                                        let id = artworkUrlArray["id"] as! String
                                        
                                        let arrayT = UserImage(id: id, image: artworkUrl, artist: artistName, sound: soundName, urlMusic: urlMusic, releaseDate: releaseDate)
                                        array.append(arrayT)
                                        
                                        let item = Item(context: PersistenceServce.contex)
                                        item.artist = artistName
                                        item.sound = soundName
                                        item.image = artworkUrl
                                        item.urlMusic = urlMusic
                                        item.releaseDate = releaseDate
                                        item.id = id
                                        
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
