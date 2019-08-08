//
//  ViewControllerImage.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerImage: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate  {

    @IBOutlet weak var imageDetail: UIImageView! {
        didSet {
            imageDetail.layer.cornerRadius = 10
            imageDetail.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var playButtonSound: UIButton! {
        didSet {
            
            playButtonSound.layer.cornerRadius = 50
            playButtonSound.layer.shadowRadius = 60
            playButtonSound.layer.shadowColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            playButtonSound.layer.shadowOpacity = 1
            playButtonSound.layer.shadowOffset = CGSize(width: 0, height: 1)
            playButtonSound.layer.shadowPath = UIBezierPath(roundedRect: playButtonSound.bounds, cornerRadius: 10).cgPath
            playButtonSound.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var viewBackShadowImage: UIView! {
        didSet {
            viewBackShadowImage.layer.shadowColor = UIColor.black.cgColor
            viewBackShadowImage.layer.shadowOpacity = 1
            viewBackShadowImage.layer.shadowOffset = CGSize(width: 0, height: 0)
            viewBackShadowImage.layer.shadowRadius = 10
            viewBackShadowImage.layer.cornerRadius = 10
            viewBackShadowImage.layer.shadowPath = UIBezierPath(roundedRect: viewBackShadowImage.bounds, cornerRadius: 10).cgPath
            viewBackShadowImage.layer.masksToBounds = false
        }
    }
    
    private let player = AVQueuePlayer()
    private var preview: AVPlayerItem?
    private var nowPlaying = false
    
    var id = ""
    var artistName = ""
    var imageName = ""
    var time = ""
    var songName = ""
    var urlMusic = ""
    var releaseDate = ""
    
    var sound = ""
    var connected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetail.downloadImage(from: imageName)
        
        nameSong.text = songName
        nameSong.textColor = UIColor(red: 0.4, green: 0.47, blue: 0.6, alpha: 1)
        
        parseJson()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        preview = nil
    }
    
    @IBAction func dateButton(_ sender: UIButton) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ViewControllerPopover") as! ViewControllerPopover
        VC.modalPresentationStyle = .popover
        VC.popoverPresentationController?.permittedArrowDirections = .down
        VC.popoverPresentationController?.delegate = self
        VC.popoverPresentationController?.sourceView = sender
        VC.popoverPresentationController?.sourceRect = sender.bounds
        VC.time = time
        VC.releaseDate = releaseDate
        present(VC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
   
    @IBAction func openMusic(_ sender: UIButton) {
        open(scheme: urlMusic)
    }
    
    func open(scheme: String) {
        if connected == true {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        }else{
           AlertDialog.showAlert("Ошибка", message: "Невозможно найти путь к программе из-за отсутствия интернета!", viewController: self)
        }
    }
    
    deinit {
        print("ViewControllerImage deinit")
    }
    
        @IBAction func playSound(_ sender: UIButton) {
            
            if connected == true {
                
                if nowPlaying == false{
                    playButtonSound.pulsate()
                
                    NotificationCenter.default.addObserver(self, selector: #selector(finishMusic), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                }
           
                if !nowPlaying {
                    if preview == nil {
                        playButtonSound.setTitle("", for: .normal)
                        
                        OperationQueue().addOperation {
                            
                                self.preview = AVPlayerItem(url: URL(string: self.sound)!)
                            
                                self.nowPlaying = true
                            
                            
                                DispatchQueue.main.sync {
                                    self.playButtonSound.setTitle("Stop", for: .normal)
                                    
                                    self.player.removeAllItems()
                                    self.player.insert(self.preview!, after: nil)
                                    self.player.play()
                                    self.player.actionAtItemEnd = .advance
                                    
                                }

                        }
                    } else {
                    nowPlaying = true
                    
                    playButtonSound.setTitle("Stop", for: .normal)
                    player.removeAllItems()
                    player.insert(preview!, after: nil)
                    player.play()
                    player.actionAtItemEnd = .advance
                    
                }
            } else {
                nowPlaying = false
                
                playButtonSound.setTitle("Res", for: .normal)
                playButtonSound.notPulsate()
                player.pause()
            }
            } else {
                AlertDialog.showAlert("Ошибка", message: "Невозможно воспроизвести мелодию из-за отсутствия интернета!", viewController: self)
            }
        }
    
    @objc func finishMusic()
    {
        nowPlaying = false
        
        playButtonSound.setTitle("Play", for: .normal)
        playButtonSound.notPulsate()
        
        self.preview = AVPlayerItem(url: URL(string: self.sound)!)
    }
    
    func parseJson() {
        
        if let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)") {
            do {
                let content = try String(contentsOf: url)
                
                let parseData = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!) as! [String: Any]
                
                if let nested = parseData["results"] as? [[String: Any]] {
                     for result in nested {
                        let preview = URL(string: String(describing: result["previewUrl"]!))
                        sound.append(String(describing: preview!))
                    }
                }
            }catch {
                print("JSON deserialization error")
            }
        }
    }
    
   
    
}

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.25
        pulse.fromValue = 0.95
        pulse.toValue = 1.05
        pulse.autoreverses = true
        pulse.repeatCount = 200
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func notPulsate() {
        layer.removeAllAnimations()
    }
}

