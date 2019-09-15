//
//  DHUILabel+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 25/01/2019.
//

import UIKit

public extension UILabel {
    
    public static func makeLabel(size: CGFloat = 13, weight: UIFont.Weight = .regular, color: UIColor = UIColor.black) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }
}
