//
//  LoadingView.swift
//  DevHelper
//
//  Created by Emil Karimov on 16.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: LoadingView
public class LoadingView: BaseFooterView {

    // MARK: - Properties
    var activityView = UIActivityIndicatorView(style: .gray)

    // MARK: - Default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.createUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    // MARK: - Get height
    override public func getViewHeight() -> CGFloat {
        return 64
    }

}

// MARK: - Private methods
extension LoadingView {

    // MARK: - UI
    private func createUI() {
        self.createActivityIndicator()
        self.makeConstraints()
    }

    // MARK: - Activity indicator
    private func createActivityIndicator() {
        self.activityView.startAnimating()
        self.addSubview(self.activityView)
    }

    // MARK: - make constraints
    private func makeConstraints() {

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width,   relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute,   multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
    }
}
