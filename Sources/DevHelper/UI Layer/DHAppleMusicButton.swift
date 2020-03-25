//
//  DHAppleMusicButton.swift
//  DevHelper
//
//  Created by Emil Karimov on 25.03.2020.
//  Copyright © 2020 ESKARIA Corp. All rights reserved.
//

import UIKit

open class DHAppleMusicButton: DHButton {

    public var type: DHSelectionType = .unselect {
        didSet {
            self.updateType(animated: false)
        }
    }

    public var selectColor: UIColor = UIColor.init(hex: "FD2D55") {
        didSet {
            self.updateType(animated: false)
        }
    }

    public var baseColor: UIColor = UIColor.init(hex: "F8F7FC") {
        didSet {
            self.updateType(animated: false)
        }
    }

    open override func commonInit() {
        super.commonInit()
        self.layer.cornerRadius = 8
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.contentEdgeInsets = UIEdgeInsets.init(top: 12, left: 27, bottom: 12, right: 27)
        self.type = .unselect
    }

    private func updateType(animated: Bool) {
        switch self.type {
        case .select:
            self.backgroundColor = self.selectColor
            self.setTitleColor(UIColor.white)
        case .unselect:
            self.backgroundColor = self.baseColor
            self.setTitleColor(self.selectColor)
        }
    }
}
