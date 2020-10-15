//
//  AudioTrack.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 22.08.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import Foundation

class AudioTrack: NSObject {
    
    var id: String?
    var image: String?
    var artist: String?
    var sound: String?
    var urlMusic: String?
    var releaseDate: String?
    let artwork: UIImage?
    let urlAppleMusic: String?
    let time: Int
    
    init(urlMusic: String, artist: String, sound: String, releaseDate: String, id: String, image: String?, artwork: UIImage?, urlAppleMusic: String, time: Int) {
       
        self.artist = artist
        self.id = id
        self.image = image
        self.sound = sound
        self.urlMusic = urlMusic
        self.releaseDate = releaseDate
        self.artwork = artwork
        self.urlAppleMusic = urlAppleMusic
        self.time = time
        
        super.init()
    }
    
//    func encode(with coder: NSCoder) {
//        coder.encode(urlMusic, forKey: "urlMusic")
//        coder.encode(artist, forKey: "artist")
//        coder.encode(sound, forKey: "sound")
//        coder.encode(releaseDate, forKey: "releaseDate")
//        coder.encode(time, forKey: "time")
//        coder.encode(id, forKey: "id")
//        coder.encode(image, forKey: "image")
//        coder.encode(artwork, forKey: "artwork")
//        coder.encode(urlAppleMusic, forKey: "urlAppleMusic")
//        coder.encode(time, forKey: "time")
//    }
//
//    required init?(coder: NSCoder) {
//        urlMusic = coder.decodeObject(forKey: "urlMusic") as? String ?? ""
//        artist = coder.decodeObject(forKey: "artist") as? String ?? ""
//        sound = coder.decodeObject(forKey: "sound") as? String ?? ""
//        releaseDate = coder.decodeObject(forKey: "releaseDate") as? String ?? ""
//        id = coder.decodeObject(forKey: "id") as? String ?? ""
//        image = coder.decodeObject(forKey: "image") as? String ?? ""
//        artwork = coder.decodeObject(forKey: "artwork") as? UIImage
//        urlAppleMusic = coder.decodeObject(forKey: "urlAppleMusic") as? String ?? ""
//        time = coder.decodeObject(forKey: "time") as? Int ?? 0
//    }
    
}

