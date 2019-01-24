//
//  DHString+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 24/01/2019.
//

import Foundation

public extension String {
    public func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
