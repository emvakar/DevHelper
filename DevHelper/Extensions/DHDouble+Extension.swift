//
//  DHDouble+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 26/02/2019.
//

import Foundation

extension Double {
    func integerPart() -> String {
        let result = floor(self).description.dropLast(2).description
        return result
    }
    func fractionalPart(_ withDecimalQty: Int = 2) -> String {
        let valDecimal = self.truncatingRemainder(dividingBy: 1)
        let formatted = String(format: "%.\(withDecimalQty)f", valDecimal)
        return formatted.dropFirst(2).description
    }
}
