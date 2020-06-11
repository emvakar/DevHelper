//
//  DHUIBarButtonItem+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public struct DHBarButtonItem {
    let icon: UIImage?
    let target: AnyObject?
    let action: Selector?
    let accessibilityName: String
}

extension UIBarButtonItem {

    /// Get compacted barbutton items
    ///
    /// - Parameter items: array of struct for buttons
    /// - Returns: only one barButton item
    public static func items(_ items: [DHBarButtonItem]) -> UIBarButtonItem {

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.frame = CGRect(x: 0, y: 0, width: 44 * items.count, height: 44)

        for item in items {

            let button = UIButton(type: .custom)
            let image = item.icon
            button.setImage(image, for: .normal)
            if let target = item.target, let action = item.action {

                button.addTarget(target, action: action, for: .touchUpInside)
            }
            button.accessibilityLabel = item.accessibilityName
            
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            stackView.addArrangedSubview(button)
        }

        return UIBarButtonItem(customView: stackView)
    }

    public static func item(icon: UIImage?, target: AnyObject?, action: Selector?, accessibilityName: String, width: CGFloat = 44, height: CGFloat = 44) -> UIBarButtonItem {

        let button = UIButton(type: .custom)
        button.setImage(icon, for: .normal)
        if let target = target, let action = action {

            button.addTarget(target, action: action, for: .touchUpInside)
        }
        button.accessibilityLabel = accessibilityName

        if #available(iOS 11, *) {

            button.heightAnchor.constraint(equalToConstant: height).isActive = true
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            
        } else {

            button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }
}
