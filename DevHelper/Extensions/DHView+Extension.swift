//
//  DHView+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 25/01/2019.
//

import UIKit

public extension UIView {
    
    public func round() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = self.layer.cornerRadius > 0
    }
    
    public func setBorders(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
