//
//  DHSegment+Extension.swift
//  DevHelper
//
//  Created by Emil Karimov on 10/03/2019.
//

import UIKit
import SnapKit

public extension UISegmentedControl {
    public func removeBorder(selectedColor: UIColor, unselectedColor: UIColor) {

        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear

        self.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17 * UIScreen.main.bounds.width / 375, weight: .medium),
            NSAttributedString.Key.foregroundColor: unselectedColor
            ], for: .normal)

        self.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17 * UIScreen.main.bounds.width / 375, weight: .medium),
            NSAttributedString.Key.foregroundColor: selectedColor
            ], for: .selected)

    }

    public func setupSegment(selectedColor: UIColor, unselectedColor: UIColor) {
        self.removeBorder(selectedColor: selectedColor, unselectedColor: unselectedColor)
        let segmentUnderlineHeight: CGFloat = 1.0
        let segmentUnderline = UIView()
        segmentUnderline.backgroundColor = unselectedColor

        self.addSubview(segmentUnderline)

        segmentUnderline.snp.remakeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(segmentUnderlineHeight)
            $0.bottom.equalToSuperview().offset(-segmentUnderlineHeight)
        }

        self.addUnderlineForSelectedSegment(selectedColor: selectedColor)

    }

    public func addUnderlineForSelectedSegment(selectedColor: UIColor) {

        let underlineHeight: CGFloat = 1.0
        let underline = UIView()
        underline.backgroundColor = selectedColor
        underline.tag = 997
        self.addSubview(underline)

        underline.snp.remakeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(self.snp.centerX)
            $0.height.equalTo(underlineHeight)
            $0.bottom.equalToSuperview().offset(-underlineHeight)
        }

    }

    public func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(997) else { return }
        let underlineFinalXPosition = (self.frame.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.snp.remakeConstraints {
            if underlineFinalXPosition == 0 {
                $0.left.equalToSuperview()
                $0.right.equalTo(self.snp.centerX)
            } else {
                $0.left.equalTo(self.snp.centerX)
                $0.right.equalToSuperview()
            }
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-1)
        }
    }
}
