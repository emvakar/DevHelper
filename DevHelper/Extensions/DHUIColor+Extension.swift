//
//  UIColor.swift
//  DevHelper
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

private var runtimeKeyAppMainColor: UInt8 = 0

public extension UIColor {

    static func RGB(r: (Int), g: (Int), b: (Int), a: (CGFloat) = 1) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }

    // To use appMainColor method, add \"Config.plist\" to your project and  insert dictionary called \"MainColor\"
    // with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1
    static func appMainColor() -> UIColor {

        // Prevent reading appMainColor from file every time
        if let appMainColor = objc_getAssociatedObject(self, &runtimeKeyAppMainColor) as? UIColor {

            return appMainColor
        } else {

            let message = "Please, add \"Config.plist\" to your project and insert dictionary called \"MainColor\" in it with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1"

            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                print("No file called \"Config.plist\" found in bundle\n\(message)")
                return .red
            }
            guard let myDict = NSDictionary(contentsOfFile: path) else {
                fatalError("\"Config.plist\" is empty\n\(message)")
            }
            guard let colorDictionary = myDict["MainColor"] as? [String: Any] else {
                fatalError("\"Config.plist\" does not have MainColor dictionary\nInsert dictionary called \"MainColor\" with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1")
            }
            guard let r = colorDictionary["red"] as? Int,
                let g = colorDictionary["green"] as? Int,
                let b = colorDictionary["blue"] as? Int,
                let a = colorDictionary["alpha"] as? CGFloat else {
                    fatalError("\"Config.plist\": red, green or blue properties were not found\nInsert fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1")
            }

            let retval = self.RGB(r: r, g: g, b: b, a: a)
            objc_setAssociatedObject(self, &runtimeKeyAppMainColor, retval, .OBJC_ASSOCIATION_COPY)
            return retval
        }
    }

    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }

    public func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

