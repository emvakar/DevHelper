//
//  ToolbarView.swift
//  DevHelper
//
//  Created by Emil Karimov on 20/03/2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FilterToolbarView
open class ToolbarView: UIView {

    // MARK: - Properties
    private var notificationView: ToolBarNotificationView! = nil
    private(set) public var filterToolbar: UIToolbar! = nil
    private var notificationBottomConstraint: NSLayoutConstraint! = nil
    private var toolBarViewContent: ToolbarStruct! = nil
    private var notificaitonViewContent: FilterNotificationStruct! = nil

    public var closeDelegate: FilterToTable? {
        get {
            return notificationView.delegate
        }
        set {
            notificationView.delegate = newValue
        }
    }

    // MARK: - Default init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom init
    init() {
        super.init(frame: .zero)
        self.toolBarViewContent = ToolbarStruct()
        self.notificaitonViewContent = FilterNotificationStruct()
        self.createUI()
    }

    public init(toolBarViewContent: ToolbarStruct = ToolbarStruct(), notificationViewContent: FilterNotificationStruct = FilterNotificationStruct()) {
        super.init(frame: .zero)
        self.toolBarViewContent = toolBarViewContent
        self.notificaitonViewContent = notificationViewContent
        self.createUI()
    }
}

// MARK: - Public methods
extension ToolbarView {
    // MARK: - Set tool bar buttons
    public func setItems(items: [UIBarButtonItem]) {
        filterToolbar.setItems(items, animated: true)
    }

    public func getItems() -> [UIBarButtonItem]? {
        return self.filterToolbar.items
    }

    // MARK: - Notificaiton text
    public func setOverviewTextFor(topLine: NSAttributedString?, bottomLine: NSAttributedString?) {
        let isVisible = topLine?.length ?? 0 > 0 || bottomLine?.length ?? 0 > 0
        notificationView.setNotificationText(topText: topLine, bottomText: bottomLine)

        if isVisible {
            self.showOverview(animation: true)
        } else {
            self.hideOverview(animation: true)
        }
    }
}

extension ToolbarView: TableToToolbarProtocol {
    // MARK: - Hide notification view
    public func hideOverview(animation: Bool) {

        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: animation ? 0.2 : 0.0) {
            self.notificationBottomConstraint.constant = CGFloat(self.toolBarViewContent.toolbarHeight)
            self.superview?.layoutIfNeeded()
        }
    }

    // MARK: - Show notification view
    public func showOverview(animation: Bool) {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: animation ? 0.2 : 0.0) {
            self.notificationBottomConstraint.constant = 0

            self.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Private methods
extension ToolbarView {

    // MARK: - UI
    private func createUI() {
        self.backgroundColor = self.toolBarViewContent.backgroundColor
        createNotifcationView(notificationViewContent: self.notificaitonViewContent)
        createToolbarView()
        makeConstraint()
    }

    // MARK: - NotificationView
    private func createNotifcationView(notificationViewContent: FilterNotificationStruct) {
        notificationView = ToolBarNotificationView.init(notificationViewContent: notificationViewContent)
        addSubview(notificationView)
    }

    // MARK: - ToolBarView
    private func createToolbarView() {
        filterToolbar = UIToolbar()
        filterToolbar.isTranslucent = false
        filterToolbar.clipsToBounds = true

        filterToolbar.backgroundColor = self.toolBarViewContent.backgroundColor
        filterToolbar.tintColor = self.toolBarViewContent.tintColor
        filterToolbar.barStyle = self.toolBarViewContent.barStyle
        filterToolbar.barTintColor = self.toolBarViewContent.barTintColor

        addSubview(filterToolbar)
    }

    // MARK: - make constraint
    private func makeConstraint() {
        
        
        let notificationViewTop = notificationView.topAnchor.constraint(equalTo: self.topAnchor)
        notificationViewTop.priority = .init(rawValue: 900)
        notificationViewTop.isActive = true
        notificationView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        notificationView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.notificationBottomConstraint = notificationView.bottomAnchor.constraint(equalTo: filterToolbar.topAnchor)
        self.notificationBottomConstraint.isActive = true

        let filterToolbarTop = filterToolbar.topAnchor.constraint(equalTo: self.topAnchor)
        filterToolbarTop.priority = .defaultLow
        filterToolbarTop.isActive = true
        filterToolbar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        filterToolbar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        filterToolbar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        filterToolbar.heightAnchor.constraint(equalToConstant: CGFloat(self.toolBarViewContent.toolbarHeight)).isActive = true
    }
}
