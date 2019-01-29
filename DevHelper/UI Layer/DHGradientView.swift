//
//  DHGradientView.swift
//  DevHelper
//
//  Created by Emil Karimov on 29/01/2019.
//

import UIKit

public enum GradientDirection {

    case up
    case left
    case right
    case down

    case leftUp
    case rightUp

    case leftDown
    case rightDown

    public var startPoint: CGPoint {
        switch self {
        case .up:
            return CGPoint(x: 0.5, y: 1)
        case .left:
            return CGPoint(x: 1, y: 0.5)
        case .right:
            return CGPoint(x: 0, y: 0.5)
        case .down:
            return CGPoint(x: 0.5, y: 0)
        case .leftUp:
            return CGPoint(x: 1, y: 1)
        case .rightUp:
            return CGPoint(x: 0, y: 1)
        case .leftDown:
            return CGPoint(x: 0, y: 0)
        case .rightDown:
            return CGPoint(x: 1, y: 0)
        }
    }

    public var endPoint: CGPoint {
        switch self {
        case .up:
            return CGPoint(x: 0.5, y: 0)
        case .left:
            return CGPoint(x: 0, y: 0.5)
        case .right:
            return CGPoint(x: 1, y: 0.5)
        case .down:
            return CGPoint(x: 0.5, y: 1)
        case .leftUp:
            return CGPoint(x: 0, y: 0)
        case .rightUp:
            return CGPoint(x: 1, y: 0)
        case .leftDown:
            return CGPoint(x: 0, y: 1)
        case .rightDown:
            return CGPoint(x: 1, y: 1)
        }
    }
}

/// Configuration struct
public struct GradientConfiguration {

    /// colors
    public let startColor: UIColor
    public let endColor: UIColor

    /// shadow
    public var shadowColor: UIColor = .clear
    public var shadowX: CGFloat = 0
    public var shadowY: CGFloat = -3
    public var shadowBlur: CGFloat = 3

    /// direction
    public var startPointX: CGFloat = 0
    public var endPointX: CGFloat = 1

    public var startPointY: CGFloat = 1
    public var endPointY: CGFloat = 0

    public var cornerRadius: CGFloat = 0

    public init(startColor: UIColor, endColor: UIColor, direction: GradientDirection? = nil, startPoint: CGPoint = GradientDirection.up.startPoint, endPoint: CGPoint = GradientDirection.up.endPoint) {
        self.startColor = startColor
        self.endColor = endColor

        guard let direction = direction else {
            self.startPointX = startPoint.x
            self.startPointY = startPoint.y

            self.endPointX = endPoint.x
            self.endPointY = endPoint.y
            return
        }

        self.startPointX = direction.startPoint.x
        self.startPointY = direction.startPoint.y

        self.endPointX = direction.endPoint.x
        self.endPointY = direction.endPoint.y

    }

}

public class DHGradientView: UIView {

    private var gradientLayer: CAGradientLayer!

    var startColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }

    var endColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }

    var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }

    var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }

    var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var startPointY: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    var endPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public init(_ config: GradientConfiguration) {
        super.init(frame: .zero)

        self.startColor = config.startColor
        self.endColor = config.endColor

        self.shadowColor = config.shadowColor
        self.shadowX = config.shadowX
        self.shadowY = config.shadowY
        self.shadowBlur = config.shadowBlur

        self.startPointX = config.startPointX
        self.endPointX = config.endPointX

        self.startPointY = config.startPointY
        self.endPointY = config.endPointY

        self.cornerRadius = config.cornerRadius

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override public func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1

    }

    public func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey: "animateGradient")
    }
}
