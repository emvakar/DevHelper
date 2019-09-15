//
//  DHUIBuilder.swift
//  DevHelper
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

/// ViewOrientation
///
/// - vertical
/// - horizontal
public enum ViewOrientation {
    case vertical
    case horizontal
}

public struct Getter {

    public func defaultInsets () -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    public func detailsInsets () -> UIEdgeInsets {
        var insets = self.defaultInsets()
        insets.top = 10
        insets.bottom = 24
        return insets
    }
}

/// Icon position
///
/// - left
/// - right
/// - center
public enum ImageInButtonPosition {
    case left
    case right
    case center
}

public struct Maker {

    public func headerView(title: String? = nil, details: String? = nil) -> DHHeaderView {

        let header = DHHeaderView()
        if let titleText = title {
            header.setTitleDetailValue(titleText, details)
        }

        return header
    }

    public func filler(orientation: ViewOrientation? = nil, size: Float? = nil) -> UIView {

        let view = UIView()
        if let orientation = orientation, let size = size {

            view.snp.makeConstraints({

                if orientation == .vertical {
                    $0.height.equalTo(size)
                } else {
                    $0.width.equalTo(size)
                }
            })
        }
        return view
    }

    /// Custom StackView
    ///
    /// - Parameters:
    ///   - orientation: Stack View orientation, vertical/horizontal
    ///   - distribution: UIStackView.Distribution
    ///   - spacing: between subviews
    /// - Returns: UIStackView
    public func stackView(orientation: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = spacing
        return stackView
    }

    public func buttonWithBottom(label: UILabel?, image: UIImage?, iconColor: UIColor, iconSize: CGFloat, cornerRadius: CGFloat = 0, showShadow: Bool) -> UIView {
        let view = UIView()
        
        let button = UIButton(type: .custom)
        view.addSubview(button)

        button.setImage(image, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = cornerRadius > 0
        button.backgroundColor = .white
        
        button.snp.makeConstraints {
            $0.width.height.equalTo(iconSize)
        }
        
        if let label = label {
            view.addSubview(label)
            let ratio: CGFloat = UIScreen.main.bounds.width / 375
            label.snp.makeConstraints {
                $0.top.equalTo(button.snp.bottom)
                $0.height.equalTo(35 * ratio)
                $0.left.equalToSuperview().offset(ratio * -11)
                $0.right.equalToSuperview().offset(ratio * 11)
                $0.bottom.equalToSuperview()
            }
            
        }
        
        if showShadow {
            button.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 7
            button.layer.masksToBounds = false
        }
        
        
        return view
    }
    
    public func buttonWithImage(icon: UIImage?, position: ImageInButtonPosition, iconColor: UIColor, size: CGSize, buttonHeigh: CGFloat? = nil, iconOffset: CGFloat? = nil) -> UIButton {
        let button = UIButton()

        guard let icon = icon else { return button }
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        button.addSubview(iconView)
        iconView.image? = (iconView.image?.withRenderingMode(.alwaysTemplate))!
        iconView.tintColor = iconColor
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            switch position {
            case .left: make.left.equalToSuperview().offset(iconOffset ?? 0)
            case .right: make.right.equalToSuperview().offset(-(iconOffset ?? 0))
            case .center: make.centerX.equalToSuperview()
            }
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        
        guard let height = buttonHeigh else { return button }
        button.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        
        return button
    }

    public func radialButton(title: String) -> UIButton {
        
        let buttonSignin = DHUIBuilder.make.roundButtonWith(title: title, fontSize: 17, height: 34, arrow: false, textAlighnment: .center, whiteBackground: false, mainColor: UIColor.RGB(r: 56, g: 209, b: 133))
        let start = UIColor.RGB(r: 86, g: 201, b: 214)
        let end = UIColor.RGB(r: 56, g: 209, b: 133)
        
        DispatchQueue.main.async {
            buttonSignin.applyGradient(start: start, end: end)
            buttonSignin.layer.cornerRadius = 10
            buttonSignin.layoutIfNeeded()
        }
        buttonSignin.setNeedsLayout()
        
        return buttonSignin
    }
    
    public func roundButtonWith(title: String, fontSize: CGFloat = 17, icon: UIImage? = nil, titleInsets: UIEdgeInsets? = nil, height: CGFloat = 44, arrow: Bool = false, textAlighnment: UIControl.ContentHorizontalAlignment = .center, whiteBackground: Bool = true, mainColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = whiteBackground ? UIColor.white : mainColor
        button.setTitleColor(whiteBackground ? mainColor : UIColor.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = textAlighnment
        if titleInsets != nil {
            button.contentEdgeInsets = titleInsets!
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        button.layer.cornerRadius = height / 2
        button.setTitle(title, for: .normal)
        if icon != nil {
            let iconView = UIImageView(image: icon!)
            iconView.contentMode = .scaleAspectFit
            button.addSubview(iconView)
            iconView.image? = (iconView.image?.withRenderingMode(.alwaysTemplate))!
            iconView.tintColor = mainColor
            iconView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(14)
                make.height.equalTo(height)
                make.width.equalTo(24)
            }
        }
        if arrow {
            let arrowView = UIImageView(image: UIImage(named: "ArrowRight"))
            arrowView.contentMode = .center
            arrowView.image = arrowView.image?.withRenderingMode(.alwaysTemplate)
            arrowView.tintColor = mainColor
            button.addSubview(arrowView)
            arrowView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-13)
            }
        }
        button.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalTo(140)
        }
        return button
    }

    public func iconLabel(image: UIImage = UIImage(), text: String?, insets: UIEdgeInsets = UIEdgeInsets.zero, uppercased: Bool) -> DHIconLabelView {
        let modifiedText = uppercased ? text?.uppercased() : text
        return DHIconLabelView(icon: image, text: modifiedText, insets: insets)
    }

}

public struct DHUIBuilder {
    public static let make = Maker()
    public static let get = Getter()

}
