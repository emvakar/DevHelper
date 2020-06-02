//
//  CurtainView.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - Base curtain view
public class CurtainView: BaseFooterView {

    // MARK: - Properties
    public var activityView = UIActivityIndicatorView(style: .gray)
    public var labelMessage = UILabel()
    public var buttonRetry = TappableButton()
    public var spacerView = UIView()
    public var cachedMessage: String?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
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
        var labelWidth: CGFloat = 0

        let windowWidth = UIScreen.main.bounds.width
        labelWidth = windowWidth - 16
        let size = CGSize(width: labelWidth, height: CGFloat(MAXFLOAT))
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: self.labelMessage.font]
        let rectangleHeight = String(describing: self.labelMessage.text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return (40 + 20 + 40 + 42 + rectangleHeight)
    }
}

//AMRK: - Actions
extension CurtainView {

    @objc func retryAction() {

        self.startLoadingView()
        self.delegate?.fetchNextPageFromView(self)
    }
}

// MARK: - Public methods
extension CurtainView {

    // MARK: - Custom init
    public convenience init(message: String?) {
        self.init(frame: .zero)
        self.labelMessage.text = message
    }

    // MARK: - Update message
    public func updateMessage(message: String?, afterSuccess: Bool = false) {
        self.cachedMessage = message
        if !afterSuccess {
            self.labelMessage.text = message
            self.cachedMessage = nil
        }
    }
}

// MARK: - Private methods
extension CurtainView {

    // MARK: - UI
    private func createUI() {
        self.createLabel()
        self.createButton()
        self.createActivityIndicator()
        self.createSpacer()
        self.makeConstraints()

        self.labelMessage.accessibilityLabel = "Table-view message"
        self.buttonRetry.accessibilityLabel = "Reload table button"
    }

    //AMRK: - Label
    private func createLabel() {
        self.labelMessage.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.labelMessage.textColor = UIColor.black
        self.labelMessage.textAlignment = .center
        self.labelMessage.numberOfLines = 0
        self.addSubview(self.labelMessage)
    }

    // MARK: - Button
    private func createButton() {
        let image = InterfaceImageProvider.getImage("refCheck")
        self.buttonRetry.setImage(image, for: .normal)
        self.buttonRetry.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        self.addSubview(self.buttonRetry)
    }

    // MARK: - Activity indicator
    private func createActivityIndicator() {
        self.activityView.hidesWhenStopped = true
        self.addSubview(self.activityView)
    }

    //Spacer
    private func createSpacer() {
        self.addSubview(self.spacerView)
    }

    //Make contraint
    private func makeConstraints() {
        //Label
        self.labelMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -8).isActive = true

        //Button
        self.buttonRetry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.labelMessage, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0).isActive = true

        //Spacer
        self.spacerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
    }

    private func startLoadingView() {
        if !self.activityView.isAnimating {
            self.activityView.startAnimating()
            self.buttonRetry.isHidden = true
        }
    }

    private func stopLoadingView() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
            self.buttonRetry.isHidden = false
        }
    }
}
