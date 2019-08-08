//
//  TableViewCell.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView! {
        didSet {
            imageViewCell.layer.cornerRadius = 10
            imageViewCell.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var viewCell: UIView! {
        didSet {
            viewCell.layer.cornerRadius = 10
            viewCell.layer.masksToBounds = true
            viewCell.backgroundColor = UIColor(red: 0.4, green: 0.50, blue: 0.70, alpha: 1)
        }
    }
    @IBOutlet weak var backImageShadowView: UIView! {
        didSet {
            backImageShadowView.layer.shadowColor = UIColor.black.cgColor
            backImageShadowView.layer.shadowOpacity = 1
            backImageShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            backImageShadowView.layer.shadowRadius = 10
            backImageShadowView.layer.cornerRadius = 10
            backImageShadowView.layer.shadowPath = UIBezierPath(roundedRect: backImageShadowView.bounds, cornerRadius: 10).cgPath
            backImageShadowView.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var artistNameCell: UILabel!
    @IBOutlet weak var soundNameCell: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    var imageURL: URL? {
        didSet {
            imageViewCell.image = nil
            downloadImageAndCache()
        }
    }

    private func downloadImageAndCache() {
        if let cachedImage = imageCache.object(forKey: imageURL?.absoluteString as AnyObject) as? UIImage {
            imageViewCell.image = cachedImage
            return
        } else if let url = imageURL {
            
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.imageViewCell.image = UIImage(data: imageData)
                            imageCache.setObject(self.imageViewCell.image!, forKey: self.imageURL?.absoluteString as AnyObject)
                            
                        }
                       
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                    }
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


extension UIImageView {
    
    func downloadImage(from url: String) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
            
        }).resume()
    }
    
}

