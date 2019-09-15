//
//  BaseErrorRetryViewProtocol.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - Table->ToolBar
public protocol TableToToolbarProtocol where Self: UIView {
    func hideOverview(animation: Bool)
    func showOverview(animation: Bool)
}

// MARK: - Filter->Table
public protocol FilterToTable: class {
    func didClickFilterNotificationClose()
}
