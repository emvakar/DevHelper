//
//  DHButton+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 25/01/2019.
//

import UIKit

public extension UIButton {
    
    public func setBorders(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
