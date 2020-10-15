//
//  RxViewControllerPlayer.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 20.08.2020.
//  Copyright © 2020 Александр Сибирцев. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxMusicPlayer
import MediaPlayer
import AVKit

class RxViewControllerPlayer: UIViewController  {
    
    private let accessibilityDateComponentsFormatter = DateComponentsFormatter()
    private let musicPlayer = RxAudioMusicPlayer.shared
    
    private var mpVolumeSlider: UISlider?
    private var pauseBottomButton: UIButton!
    private var nextBottomButton: UIButton!
    
    // MARK: Interface builder outlets

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var slider: ProgressSlider!
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: MarqueeLabel!
    
    @IBOutlet weak var artistLabel: MarqueeLabel!
    
    @IBOutlet weak var volumeParentView: UIView!
    @IBOutlet weak var airPlayView: UIView!
    
    @IBOutlet weak var goAppleMusikButton: UIButton! 

    @IBOutlet private var rateButton: UIButton!
    
    // MARK: Parameters
    var songTitle: String = "" {
        didSet {
            if isViewLoaded {
                titleLabel.text = songTitle
            }

            popupItem.title = songTitle
        }
    }

    var albumTitle: String = "" {
        didSet {
            if isViewLoaded {
                artistLabel.text = albumTitle
            }

            popupItem.subtitle = albumTitle
           
        }
    }

    var albumArt: UIImage = UIImage() {
        didSet {
            if isViewLoaded {
                artImageView.image = albumArt
            }
            popupItem.image = albumArt
            popupItem.accessibilityImageLabel = NSLocalizedString("Album Art", comment: "")
        }
    }
    
    // MARK: View controller lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        pauseBottomButton = UIButton(type: .system)
        pauseBottomButton?.setImage(UIImage(named: "pause"), for: UIControl.State())
        pauseBottomButton.tintColor = .black
        
        let pauseBarButtonItem = UIBarButtonItem(customView: pauseBottomButton!)
        pauseBarButtonItem.accessibilityLabel = NSLocalizedString("Pause", comment: "")
        
        nextBottomButton = UIButton(type: .system)
        nextBottomButton?.setImage(UIImage(named: "nextFwd"), for: UIControl.State())
        nextBottomButton.tintColor = .black
        let nextBarButtonItem = UIBarButtonItem(customView: nextBottomButton!)
        nextBarButtonItem.accessibilityLabel = NSLocalizedString("Next Track", comment: "")
        
        let oldOS : Bool
        #if !targetEnvironment(macCatalyst)
        oldOS = ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 10
        #else
        oldOS = false
        #endif
        
        if UserDefaults.standard.object(forKey: PopupSettingsBarStyle) as? LNPopupBarStyle == LNPopupBarStyle.compact || oldOS {
            popupItem.leftBarButtonItems = [ pauseBarButtonItem ]
            popupItem.rightBarButtonItems = [ nextBarButtonItem ]
        } else {
            popupItem.rightBarButtonItems = [ pauseBarButtonItem, nextBarButtonItem ]
        }
        
        accessibilityDateComponentsFormatter.unitsStyle = .spellOut
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMusicPlayer()
        
        titleLabel.type = .continuous
        titleLabel.speed = .duration(15)
        titleLabel.animationCurve = .easeInOut
        titleLabel.fadeLength = 10.0
        titleLabel.leadingBuffer = 30.0
        titleLabel.isUserInteractionEnabled = true
        
        artistLabel.type = .continuous
        artistLabel.speed = .duration(15)
        artistLabel.animationCurve = .easeInOut
        artistLabel.fadeLength = 10.0
        artistLabel.leadingBuffer = 30.0
        artistLabel.isUserInteractionEnabled = true
        
        if #available(iOS 13.0, *) {
            artImageView.layer.cornerCurve = .continuous
        }
        artImageView.layer.cornerRadius = 16
        
        setupVolumeSlider()
        setupAirPlayButton()

    }

    // MARK: Setup
    
    private func setupVolumeSlider() {
        for subview in MPVolumeView().subviews {
            guard let volumeSlider = subview as? UISlider else {
                continue
            }
            mpVolumeSlider = volumeSlider
        }
        
        guard let mpVolumeSlider = mpVolumeSlider else {
            return
        }
        
        volumeParentView.addSubview(mpVolumeSlider)
        
        mpVolumeSlider.translatesAutoresizingMaskIntoConstraints = false
        mpVolumeSlider.leftAnchor.constraint(equalTo: volumeParentView.leftAnchor).isActive = true
        mpVolumeSlider.rightAnchor.constraint(equalTo: volumeParentView.rightAnchor).isActive = true
        mpVolumeSlider.centerYAnchor.constraint(equalTo: volumeParentView.centerYAnchor).isActive = true
        
        mpVolumeSlider.minimumTrackTintColor = #colorLiteral(red: 0.4395738244, green: 0.3904562891, blue: 0.8513493538, alpha: 1)
        mpVolumeSlider.maximumTrackTintColor = .lightGray
        mpVolumeSlider.thumbTintColor = .white
    }
    
    private func setupAirPlayButton() {
        airPlayView.isHidden = false
        
        if #available(iOS 11.0, *) {
            let airPlayButton = AVRoutePickerView(frame: airPlayView.bounds)
            airPlayButton.activeTintColor = UIColor(red: 0, green: 189/255, blue: 233/255, alpha: 1)
            airPlayButton.tintColor = .darkGray
            airPlayView.backgroundColor = .clear
            airPlayView.addSubview(airPlayButton)
        } else {
            let airPlayButton = MPVolumeView(frame: airPlayView.bounds)
            airPlayButton.showsVolumeSlider = false
            airPlayButton.tintColor = .darkGray
            airPlayView.backgroundColor = .clear
            airPlayView.addSubview(airPlayButton)
        }
    }
    
    private func setupMusicPlayer() {
        musicPlayer.player?.rx.canSendCommand(cmd: .play)
            .do(onNext: { [weak self] canPlay in
                self?.playButton.setImage(canPlay ? UIImage(named: "nowPlaying_play") : UIImage(named: "nowPlaying_pause"), for: UIControl.State())
                self?.pauseBottomButton?.setImage(canPlay ? UIImage(named: "playB") : UIImage(named: "pause"), for: UIControl.State())
            })
            .drive()
            .disposed(by: musicPlayer.disposeBag)
            
        musicPlayer.player?.rx.canSendCommand(cmd: .next)
            .drive(nextButton.rx.isEnabled)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.canSendCommand(cmd: .next)
            .drive(nextBottomButton.rx.isEnabled)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.canSendCommand(cmd: .previous)
            .drive(prevButton.rx.isEnabled)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.currentItemTitle()
            .drive(titleLabel.rx.text)
            .disposed(by: musicPlayer.disposeBag)

        musicPlayer.player?.rx.currentItemArtist()
            .drive(artistLabel.rx.text)
            .disposed(by: musicPlayer.disposeBag)

        musicPlayer.player?.rx.currentItemArtwork()
            .drive(artImageView.rx.image)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.canSendCommand(cmd: .seek(seconds: 0, shouldPlay: false))
            .drive(slider.rx.isUserInteractionEnabled)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.currentItemRestDurationDisplay().map {
            guard let rest = $0 else { return "--:--" }
            return "-\(rest)"
        }
        .drive(remainingTimeLabel.rx.text)
        .disposed(by: musicPlayer.disposeBag)
                
        musicPlayer.player?.rx.currentItemTimeDisplay()
            .drive(elapsedTimeLabel.rx.text)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.currentItemDuration()
            .map { Float($0?.seconds ?? 0) }
            .do(onNext: { [weak self] in
                self?.slider.maximumValue = $0
            })
            .drive()
            .disposed(by: musicPlayer.disposeBag)
            
        let seekValuePass = BehaviorRelay<Bool>(value: true)
        musicPlayer.player?.rx.currentItemTime()
            .withLatestFrom(seekValuePass.asDriver()) { ($0, $1) }
            .filter { $0.1 }
            .map {
                return Float($0.0?.seconds ?? 0)
            }
            .drive(slider.rx.value)
            .disposed(by: musicPlayer.disposeBag)
            
        slider.rx.controlEvent(.touchDown)
            .do(onNext: {
                seekValuePass.accept(false)
            })
            .subscribe()
            .disposed(by: musicPlayer.disposeBag)
        
        slider.rx.controlEvent(.touchUpInside)
            .do(onNext: {
                seekValuePass.accept(true)
            })
            .subscribe()
            .disposed(by: musicPlayer.disposeBag)
            
        musicPlayer.player?.rx.currentItemLoadedProgressRate()
            .drive(slider.rx.playableProgress)
            .disposed(by: musicPlayer.disposeBag)
        
        musicPlayer.player?.rx.playerIndex()
            .do(onNext: { index in
                guard let track = self.musicPlayer.sources?[index] else {
                    return
                }
            
                if let artwork = track.artwork {
                    self.albumArt = artwork
                }
                
                self.songTitle = track.sound!
                self.albumTitle = track.artist!
                
                if index == self.musicPlayer.player!.queuedItems.count - 1 {
                    // You can remove the comment-out below to confirm the append().
                    // player.append(items: items)
                }
            })
            .drive()
            .disposed(by: musicPlayer.disposeBag)
            
        // 3) Process the user's input
        let cmd = Driver.merge(
            playButton.rx.tap.asDriver().map { [weak self] in
                if self?.playButton.currentImage == UIImage(named: "nowPlaying_play") {
                    return RxMusicPlayer.Command.play
                }
                return RxMusicPlayer.Command.pause
            },
            nextButton.rx.tap.asDriver().map { RxMusicPlayer.Command.next },
            prevButton.rx.tap.asDriver().map { RxMusicPlayer.Command.previous },
            nextBottomButton.rx.tap.asDriver().map { RxMusicPlayer.Command.next },
            pauseBottomButton.rx.tap.asDriver().map { [weak self] in
                if self?.pauseBottomButton.currentImage == UIImage(named: "playB") {
                    return RxMusicPlayer.Command.play
                }
                return RxMusicPlayer.Command.pause
            },
            slider.rx.controlEvent(.valueChanged).asDriver()
                .map { [weak self] _ in
                    RxMusicPlayer.Command.seek(seconds: Int(self?.slider.value ?? 0), shouldPlay: false)
            }
            .distinctUntilChanged())
            .startWith(.prefetch)
        
        musicPlayer.player?.run(cmd: cmd)
            .do(onNext: { status in
                UIApplication.shared.isNetworkActivityIndicatorVisible = status == .loading
            })
            .flatMap { [weak self] status -> Driver<()> in
                guard let self = self else { return .just(()) }
                
                switch status {
                case let RxMusicPlayer.Status.failed(err: err):
                    print("RxMusicPlayer.Status.failed", err)
                case let RxMusicPlayer.Status.critical(err: err):
                    print("RxMusicPlayer.Status.critical", err)
                case RxMusicPlayer.Status.readyToPlay:
                    print("Read to play")
                    self.playButton.sendActions(for: .touchUpInside)
                default:
                    print("status", status)
                }
                
                return .just(())
        }
        .drive()
        .disposed(by: musicPlayer.disposeBag)
        
        rateButton.rx.tap.asDriver()
        .flatMapLatest { [weak self] _ -> Driver<()> in
            guard let weakSelf = self else { return .just(()) }
                
            return Wireframe.promptSimpleActionSheetFor(
                src: weakSelf,
                cancelAction: "Отмена",
                actions: PlaybackRateAction.allCases.map {
                    self?.musicPlayer.player?.desiredPlaybackRate == $0.toFloat ? "\($0.rawValue) ✓" : $0.rawValue })
                
                .do(onNext: { [weak self] action in
                    if let rate = PlaybackRateAction(rawValue: action)?.toFloat {
                        self?.musicPlayer.player?.desiredPlaybackRate = rate
                    }
                })
                .map { _ in }
        }
        .drive()
        .disposed(by: musicPlayer.disposeBag)
    }
    
    // MARK: Actions
    
    @IBAction func favoriteAydioAction(_ sender: UIButton) {
        let index = self.musicPlayer.player!.playIndex
        open(scheme: musicPlayer.sources![index].urlAppleMusic!)
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
}
