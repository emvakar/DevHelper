//
//  ImageProvider.swift
//  DevHelper
//
//  Created by Emil Karimov on 05/04/2019.
//  Copyright © 2019 ESKARIA Corp. All rights reserved.
//

import UIKit

public class InterfaceImageProvider {

    private static var bundle: Bundle?
    private static let onceTracker: () = {

        if let bundleURL = Bundle(for: InterfaceImageProvider.self).url(forResource: "InterfaceAssets", withExtension: "bundle") {

            if let bundle = Bundle(url: bundleURL) {

                InterfaceImageProvider.bundle = bundle
            }
        }
    }()

    public static func getImage(_ named: String?) -> UIImage? {

        guard let named = named else {
            return nil
        }
        _ = self.onceTracker
        guard let bundle = self.bundle else {
            return nil
        }
        let image = UIImage(named: named, in: bundle, compatibleWith: nil)
        return image
    }
}
