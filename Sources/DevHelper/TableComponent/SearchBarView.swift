//
//  SearchBarView.swift
//  DevHelper
//
//  Created by Emil Karimov on 11.04.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import Foundation
import UIKit

public struct SearchBarViewContent {

    public var placeholderText: String = "Поиск"
    public var searchImage: UIImage?
    public var cancelImage: UIImage?
    public var cancelText: String = "Отмена"
    public var fieldBackground: UIColor = UIColor.white
    public var background: UIColor = UIColor.white

    public init() { }
}

open class SearchBarView: UISearchBar {

    private var searchBarViewContent: SearchBarViewContent

    public init(searchBarViewContent: SearchBarViewContent) {
        self.searchBarViewContent = searchBarViewContent
        super.init(frame: .zero)

        self.tintColor = UIColor.white
        self.backgroundImage = UIImage()
        self.placeholder = searchBarViewContent.placeholderText
        self.clipsToBounds = true

        self.layer.borderColor = searchBarViewContent.background.cgColor
        self.layer.cornerRadius = 0
        self.searchBarStyle = UISearchBar.Style.prominent

        self.setImage(searchBarViewContent.searchImage, for: .search, state: .normal)
        self.setImage(searchBarViewContent.cancelImage, for: .clear, state: .normal)

        self.barTintColor = searchBarViewContent.background
        self.backgroundColor = searchBarViewContent.background

        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        barButtonAppearance.title = searchBarViewContent.cancelText
        barButtonAppearance.tintColor = UIColor.white

        let searchPlaceholderLabelApperance = UILabel.appearance(whenContainedInInstancesOf: [UITextField.self, UISearchBar.self])
        searchPlaceholderLabelApperance.textColor = UIColor.white
        searchPlaceholderLabelApperance.alpha = 0.5

        let searchBarIconAppearance = UIImageView.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarIconAppearance.tintColor = UIColor.white

        self.subviews[0].subviews.compactMap { $0 as? UITextField }.first?.tintColor = UIColor.white
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField {

            textFieldInsideSearchBar.textColor = UIColor.white
            textFieldInsideSearchBar.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            textFieldInsideSearchBar.backgroundColor = searchBarViewContent.fieldBackground
            textFieldInsideSearchBar.textAlignment = .left
            textFieldInsideSearchBar.accessibilityLabel = "search Field"

            if let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = UIColor.white.withAlphaComponent(0.5)
            }
            if let clearButton = textFieldInsideSearchBar.value(forKey: "_clearButton") as? UIButton {
                let image = searchBarViewContent.cancelImage
                clearButton.setImage(image, for: .normal)
                clearButton.tintColor = .white
            }
        }

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
