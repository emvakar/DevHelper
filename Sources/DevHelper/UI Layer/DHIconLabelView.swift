//
//  DHIconLabelView.swift
//  DevHelper
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class DHIconLabelView: UIView {

    public var label: UILabel! = UILabel()//size: 13, weight: UIFont.Weight.regular.rawValue, color: UIColor.appHeadertextColor())
    public var iconView: UIImageView! = nil
    var insets: UIEdgeInsets?

    public convenience init() {
        self.init(frame: .zero)
    }
    public convenience init(icon: UIImage = UIImage(), text: String? = nil, insets: UIEdgeInsets = UIEdgeInsets.zero) {

        self.init()
        self.label?.text = text
        self.label.numberOfLines = 0
        self.iconView = UIImageView(image: icon)
        self.iconView.contentMode = .scaleAspectFit
        self.insets = insets

        let container = UIView()
        self.addSubview(container)
        
        container.topAnchor.constraint(equalTo: self.topAnchor, constant: self.insets?.top ?? 0).isActive = true
        container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.insets?.bottom ?? 0).isActive = true
        container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.insets?.left ?? 0).isActive = true
        container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: self.insets?.right ?? 0).isActive = true
       
        container.addSubview(self.iconView)
        
        self.iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 2).isActive = true
        self.iconView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        self.iconView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        self.iconView.widthAnchor.constraint(equalToConstant: 13).isActive = true

        container.addSubview(self.label)
        
        self.label.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.iconView.leftAnchor, constant: 8).isActive = true
        self.label.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String, uppercased: Bool = false) {
        self.label.text = uppercased ? text.uppercased() : text
    }
}
