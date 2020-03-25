//
//  DHAnimation.swift
//  DevHelper
//
//  Created by Emil Karimov on 25.03.2020.
//  Copyright © 2020 ESKARIA Corp. All rights reserved.
//

import UIKit

public enum DHAnimation {

    public static func animate(_ duration: TimeInterval, animations: (() -> Void)!, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], withComplection completion: (() -> Void)! = { }) {

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: {
                animations()
            }, completion: { _ in
                completion()
            })
    }

    public static func animateWithRepeatition(_ duration: TimeInterval, animations: (() -> Void)!, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], withComplection completion: (() -> Void)! = { }) {

        var optionsWithRepeatition = options
        optionsWithRepeatition.insert([.autoreverse, .repeat, .allowUserInteraction])

        self.animate(
            duration,
            animations: {
                animations()
            },
            delay: delay,
            options: optionsWithRepeatition,
            withComplection: {
                completion()
            })
    }
}
