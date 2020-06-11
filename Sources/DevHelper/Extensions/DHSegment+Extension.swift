//
//  DHSegment+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 10/03/2019.
//

import UIKit
import SnapKit

public extension UISegmentedControl {
    public func removeBorder(selectedColor: UIColor, unselectedColor: UIColor) {

        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear

        self.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17 * UIScreen.main.bounds.width / 375, weight: .medium),
            NSAttributedString.Key.foregroundColor: unselectedColor,
            NSAttributedString.Key.underlineColor: unselectedColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ], for: .normal)

        self.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17 * UIScreen.main.bounds.width / 375, weight: .medium),
            NSAttributedString.Key.foregroundColor: selectedColor,
            NSAttributedString.Key.underlineColor: selectedColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ], for: .selected)
    }

    public func setupSegment(selectedColor: UIColor, unselectedColor: UIColor) {
        self.removeBorder(selectedColor: selectedColor, unselectedColor: unselectedColor)

    }

    public func addUnderlineForSelectedSegment(selectedColor: UIColor) {

        let underlineHeight: CGFloat = 1.0
        let underline = UIView()
        underline.backgroundColor = selectedColor
        underline.tag = 997
        self.addSubview(underline)
        
        underline.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -underlineHeight).isActive = true
        underline.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        underline.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        underline.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
    }

    public func changeUnderlinePosition() {

    }
}
