//
//  UserInfoImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 05/07/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class UserInfoImage: NSObject {
    
    static let urlString = "https://rss.itunes.apple.com/api/v1/ru/apple-music/top-songs/all/10/explicit.json"
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func forecast(completion: @escaping ([AudioTrack]) -> ()) {
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                var array: [AudioTrack] = []
                
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                    //print(jsonArray)
                    if let feed = jsonArray["feed"] as? [String: AnyObject] {
                        if let results = feed["results"] as? NSArray {
                           
                            for i in results {
                                if let artworkUrlArray = i as? [String: AnyObject] {
                                   
                                    let artworkUrl = artworkUrlArray["artworkUrl100"] as! String
                                    let artistName = artworkUrlArray["artistName"] as! String
                                    let soundName = artworkUrlArray["name"] as! String
                                    let urlAppleMusic = artworkUrlArray["url"] as! String
                                    let releaseDate = artworkUrlArray["releaseDate"] as? String
                                    let id = artworkUrlArray["id"] as! String
                                    
                                    var urlMusic = String()
                                    var artwork = UIImage()

                                    if let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)") {
                                        do {
                                            let content = try String(contentsOf: url)
                                            
                                            let parseData = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!) as! [String: Any]
                                            
                                            if let nested = parseData["results"] as? [[String: Any]] {
                                                for result in nested {
                                                    let preview = URL(string: String(describing: result["previewUrl"]!))
                                                    urlMusic = String(describing: preview!)
                                                    
                                                    
                                                }
                                            }
                                        }catch {
                                            print("JSON deserialization error")
                                        }
                                    }
                                    
                                    
                                   
                                    if let url = URL(string: artworkUrl) {
                                        do {
                                            let data = try Data(contentsOf: url)
                                            artwork = UIImage(data: data)!
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    
                                    let videoURL = URL(fileURLWithPath: urlMusic as String)
                                    let duration = AVURLAsset(url: videoURL).duration.seconds
                                    
                                    let arrayTrack = AudioTrack(urlMusic: urlMusic, artist: artistName, sound: soundName, releaseDate: releaseDate ?? "", id: id, image: artworkUrl, artwork: artwork, urlAppleMusic: urlAppleMusic, time: Int(duration))
                                    array.append(arrayTrack)
                                    
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
