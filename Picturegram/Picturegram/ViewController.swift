//
//  ViewController.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit
import Kingfisher
import LNPopupController

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadTableViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadTableViewLabel: UILabel!
    
    @IBOutlet weak var buildVersionLabel: UILabel!
   
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"
    
    var kTableHeaderHeight:CGFloat = 250.0
    var headerView: UIView!
    
    let musicPlayer = RxAudioMusicPlayer.shared
    var audioTracks: [AudioTrack]?
    
    required init?(coder aDecoder: NSCoder) {
        audioTracks = []
        
        super.init(coder:aDecoder)
    }
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ReachabilityManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        ReachabilityManager.isReachable { _ in
            UserInfoImage.forecast { ( results ) in
                for i in results {
                    let arrayT = AudioTrack(urlMusic: i.urlMusic ?? "", artist: i.artist ?? "", sound: i.sound ?? "", releaseDate: i.releaseDate ?? "", id: i.id ?? "", image: i.image, artwork: i.artwork, urlAppleMusic: i.urlAppleMusic ?? "", time: i.time)
                    self.audioTracks!.append(arrayT)
                    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
    }
    
    func showOfflinePage() -> Void {
        DispatchQueue.main.async {
    
            let viewControllerMessageList = self.storyboard?.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
            self.navigationController?.pushViewController(viewControllerMessageList, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        #if !targetEnvironment(macCatalyst)
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion <= 10 {
            let insets = UIEdgeInsets.init(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
        #endif
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 385
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioTracks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let item = audioTracks![indexPath.row]
        
        cell.artistNameCell.text = item.artist
        cell.soundNameCell.text = item.sound
        cell.topLabel.text = "Топ \(indexPath.row + 1)"
        
        cell.imageViewCell.kf.indicatorType = .activity
        cell.imageViewCell.kf.setImage(with: URL(string: item.image ?? ""))
        
        //cell.indentationLevel = 2
        cell.selectionStyle = .none
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popupContentController = storyboard?.instantiateViewController(withIdentifier: "RxViewControllerPlayer") as! RxViewControllerPlayer
      
        musicPlayer.addSource(audioTracks!, startAt: indexPath.row)
    
        popupContentController.popupItem.accessibilityHint = NSLocalizedString("Double Tap to Expand the Mini Player", comment: "")
        tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        
        tabBarController?.popupBar.marqueeScrollEnabled = true
        
        #if targetEnvironment(macCatalyst)
        tabBarController?.popupBar.inheritsVisualStyleFromDockingView = true
        #endif
        
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        
        if #available(iOS 13.0, *) {
            tabBarController?.popupBar.tintColor = UIColor.label
        } else {
            tabBarController?.popupBar.tintColor = UIColor(white: 38.0 / 255.0, alpha: 1.0)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



