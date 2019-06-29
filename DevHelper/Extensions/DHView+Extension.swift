//
//  DHView+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 25/01/2019.
//

import UIKit

public extension UIView {
    
    public func applyGradient(start: UIColor, end: UIColor) -> Void {
        
        self.applyGradient(colours: [start, end], locations: [0.0, 1.0])
    }
    
    private func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        self.cornerRadius(self.frame.height / 2)
    }

    public func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = radius > 0
    }
    
    /// Set rounded corner radius
    public func round() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = self.layer.cornerRadius > 0
    }
    
    /// Set Borders to View
    ///
    /// - Parameters:
    ///   - borderColor: Color of border
    ///   - borderWidth: Width of border
    public func setBorders(borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    /// Remove borders
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
