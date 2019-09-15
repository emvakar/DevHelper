//
//  DHDouble+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 26/02/2019.
//

import Foundation

public extension Double {

    public func integerPart() -> String {
        let result = floor(self).description.dropLast(2).description
        return result
    }

    public func fractionalPart(_ withDecimalQty: Int = 2) -> String {
        let valDecimal = self.truncatingRemainder(dividingBy: 1)
        let formatted = String(format: "%.\(withDecimalQty)f", valDecimal)
        return formatted.dropFirst(2).description
    }
    
    public func roundWithPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
