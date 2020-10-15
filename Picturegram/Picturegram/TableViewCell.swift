//
//  TableViewCell.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 19/06/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import UIKit

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
            viewCell.backgroundColor = #colorLiteral(red: 0.4395738244, green: 0.3904562891, blue: 0.8513493538, alpha: 1)
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
    
    @IBOutlet weak var artistNameCell: UILabel!
    @IBOutlet weak var soundNameCell: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

