//
//  TableConfiguration.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - TableConfiguration
public class TableConfiguration {

    // MARK: - Properties
    let tableOptions: TableOptions
    let cellClasses: [AnyClass]

    // MARK: - Initialization
    public init(options: TableOptions,  cellClasses: [AnyClass]) {
        if cellClasses.count < 1 {
            fatalError("TableViewController requires at least 1 cell class to work with")
        }

        self.tableOptions = options
        self.cellClasses = cellClasses
    }
}

// MARK: - NSCopying extesntion
extension TableConfiguration: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return TableConfiguration(options: self.tableOptions, cellClasses: self.cellClasses)
    }
}
