//
//  Colors.swift
//  Picturegram
//
//  Created by Александр Сибирцев on 23/07/2019.
//  Copyright © 2019 Александр Сибирцев. All rights reserved.
//

import Foundation
import UIKit

class Colors{
    var gl: CAGradientLayer!
    
    init() {
        
        let arrayColor = [[UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1).cgColor, UIColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 125/255, blue: 80/255, alpha: 1).cgColor, UIColor(red: 140/255, green: 70/255, blue: 20/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 125/255, blue: 80/255, alpha: 1).cgColor, UIColor(red: 140/255, green: 70/255, blue: 20/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 125/255, blue: 80/255, alpha: 1).cgColor, UIColor(red: 140/255, green: 70/255, blue: 20/255, alpha: 1).cgColor],
                          [UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor,UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor],
                          [UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor,UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor],
                          [UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor,UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor, UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor, UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor],
                          [UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor, UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor]]
        
//         UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor розовый
//         UIColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1).cgColor голубой
//         UIColor(red: 25/255, green: 25/255, blue: 115/255, alpha: 1).cgColor синий
//         UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1).cgColor зеленый
//         UIColor(red: 255/255, green: 125/255, blue: 80/255, alpha: 1).cgColor персик
//         UIColor(red: 140/255, green: 70/255, blue: 20/255, alpha: 1).cgColor коричневый
//
        
        for i in arrayColor {
            for j in i {
            self.gl = CAGradientLayer()
            self.gl.colors = [j]
            self.gl.locations = [0.0, 1.0]
            }

        }

        self.gl = CAGradientLayer()
        self.gl.colors = [arrayColor.randomElement()!].randomElement()
        self.gl.locations = [0.0, 1.0]
    }
    
}
