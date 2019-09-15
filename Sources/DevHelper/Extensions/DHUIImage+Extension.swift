//
//  DHUIImage+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 29/01/2019.
//

import UIKit

public extension UIImage {

    /// Colorize image
    ///
    /// - Parameter color: new color for image
    /// - Returns: new colorized image
    func mask(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)

        color.setFill()
        context.fill(rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return newImage
    }
}
