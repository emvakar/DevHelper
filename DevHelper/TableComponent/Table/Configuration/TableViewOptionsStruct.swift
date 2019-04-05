//
//  TableConfigurationStruct.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - TableView view options (e.g. SearchBar, ToolBar, Refresh, Paged)
public struct TableOptions: OptionSet {
    public let rawValue: Int

    public static let paged          = TableOptions(rawValue: 1 << 0)
    public static let refreshControl = TableOptions(rawValue: 1 << 1)
    public static let searchBar      = TableOptions(rawValue: 1 << 2)
    public static let toolBar        = TableOptions(rawValue: 1 << 3)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
