//
//  UIView+Extension.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

extension UIView {
    func circle() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func rounded() {
       circle()
    }
    
    func shadow() {
        self.layer.shouldRasterize = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    func border(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
