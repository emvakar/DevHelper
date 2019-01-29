//
//  DHUITextView+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 25/01/2019.
//

import UIKit

extension UITextView {
    
    static func makeTextView(size: CGFloat = 13, weight: UIFont.Weight = .regular, textColor: UIColor) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: size, weight: weight)
        textView.textColor = textColor
        return textView
    }
}
