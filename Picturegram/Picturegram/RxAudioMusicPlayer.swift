//
//  RxAudioMusicPlayer.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 20.08.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import CoreMedia
import RxCocoa
import RxSwift
import RxMusicPlayer

class RxAudioMusicPlayer: NSObject {
    
    static let shared = RxAudioMusicPlayer()
    
    var player: RxMusicPlayer?
    var sources: [AudioTrack]?
    var disposeBag = DisposeBag()
    
    private override init() {
        super.init()
    }
    
    func addSource(_ sources: [AudioTrack], startAt playIndex: Int) {
        self.sources = sources

        let items = sources.map { self.playerItem(from: $0) }

        disposeBag = DisposeBag()

        player = RxMusicPlayer(items: items)
        player?.playIndex = playIndex

    }
    
    private func playerItem(from source: AudioTrack) -> RxMusicPlayerItem {
        let duration = CMTime(seconds: Double(source.time), preferredTimescale: 1)
        
        let meta = RxMusicPlayerItem.Meta(
            duration: duration,
            lyrics: nil,
            title: source.sound,
            album: source.sound,
            artist: source.artist,
            artwork: source.artwork
        )
        
        let url = URL(string: source.urlMusic ?? "")!
        
        return RxMusicPlayerItem(url: url, meta: meta)
    }
    
}

