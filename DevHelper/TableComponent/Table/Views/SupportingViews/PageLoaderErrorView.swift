//
//  BaseRetryView.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - Base retry error view
public class PageLoaderErrorView: BaseFooterView {

    // MARK: - Properties
    private var titleLabel = UILabel()
    private var retryButton = TappableButton(type: .custom)
    private var activityView = UIActivityIndicatorView(style: .white)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 241.0 / 255.0, green: 84.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
        self.createUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - TableToViewProtocol
    override public func displayActivity(_ inProgress: Bool) {
        inProgress ? startLoadingView() : stopLoadingView()
    }

    override public func getViewHeight() -> CGFloat {
        return 64
    }
}

// MARK: - Custom init
extension PageLoaderErrorView {
    convenience init(title: String = "Произошла ошибка", image: UIImage = (InterfaceImageProvider.getImage("refresh") ?? UIImage())) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.retryButton.setImage(image, for: .normal)
    }
}

// MARK: - Actions
extension PageLoaderErrorView {

    @objc func retryAction() {

        self.startLoadingView()
        self.delegate?.fetchNextPageFromView(self)
    }
}

// MARK: - Public methods
extension PageLoaderErrorView {

    public func updateMessage(_ message: String?) {

        self.titleLabel.text = message
    }
}

// MARK: - Private methods
extension PageLoaderErrorView {

    // MARK: - UI subviews
    private func createUI() {
        self.createTitleLabel()
        self.createRetryButton()
        self.createActivityIndicator()

        self.makeConstraints()
    }

    // MARK: - Label
    private func createTitleLabel() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.text = "Произошла ошибка"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
    }

    // MARK: - Button
    private func createRetryButton() {
        let image = InterfaceImageProvider.getImage("refresh")
        self.retryButton.setImage(image, for: .normal)
        self.retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        self.addSubview(self.retryButton)
    }

    // MARK: - Activity indicator
    private func createActivityIndicator() {
        self.activityView.hidesWhenStopped = true
        self.addSubview(self.activityView)
    }

    // MARK: - Make constraints
    private func makeConstraints() {
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true

        //Button
        self.retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.right,   relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right,   multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.width,   relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.height,  relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true

        //Label
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.top,    relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top,    multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.right,  relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.left,   multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.left,   relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left,   multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 64).isActive = true

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.height,  relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.height,  multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width,   relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.width,   multiplier: 1, constant: 0).isActive = true
    }

    private func stopLoadingView() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
            self.retryButton.isHidden = !self.activityView.isHidden
        }
    }

    private func startLoadingView() {
        if !self.activityView.isAnimating {
            self.activityView.startAnimating()
            self.retryButton.isHidden = !self.activityView.isHidden
        }
    }
}
