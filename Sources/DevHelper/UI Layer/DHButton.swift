//
//  DHButton.swift
//  DevHelper
//
//  Created by Emil Karimov on 25.03.2020.
//  Copyright © 2020 ESKARIA Corp. All rights reserved.
//

import UIKit

public enum DHSelectionType {
    case select
    case unselect
}

open class DHButton: UIButton {

    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.title(for: .normal) != nil {
            let inset: CGFloat = 6
            let sideSize = self.frame.height - inset * 2
            let titleFrame = self.titleRect(forContentRect: contentRect)
            return CGRect.init(x: titleFrame.origin.x - sideSize - 6, y: 0, width: sideSize, height: self.frame.height)
        } else {
            return super.imageRect(forContentRect: contentRect)
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.imageView?.alpha = 0.7
            } else {
                self.imageView?.alpha = 1
            }
        }
    }

    public var rounded: Bool = false {
        didSet {
            self.layoutSubviews()
        }
    }

    public init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    internal func commonInit() {
        self.adjustsImageWhenHighlighted = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.rounded {
            self.round()
        }
    }

    public func set(enable: Bool, animatable: Bool) {
        self.isEnabled = enable
        if animatable {
            DHAnimation.animate(0.3, animations: {
                self.alpha = enable ? 1 : 0.6
            })
        } else {
            self.alpha = enable ? 1 : 0.6
        }
    }
}

extension UIButton {

    public  typealias UIButtonTargetClosure = () -> Void

    private class ClosureWrapper: NSObject {
        let closure: UIButtonTargetClosure
        init(_ closure: @escaping UIButtonTargetClosure) {
            self.closure = closure
        }
    }

    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }

    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func target(_ action: @escaping UIButtonTargetClosure) {
        targetClosure = action
        addTarget(self, action: #selector(UIButton.targetAction), for: .touchUpInside)
    }

    @objc func targetAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure()
    }
}

extension UIButton {

    public func setTitle(_ title: String, color: UIColor? = nil) {
        self.setTitle(title, for: .normal)
        if let color = color {
            self.setTitleColor(color)
        }
    }

    public func setTitleColor(_ color: UIColor) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color.withAlphaComponent(0.7), for: .highlighted)
    }

    public func setImage(_ image: UIImage) {
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }

    public func removeAllTargets() {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }

    public func showText(_ text: String, withComplection completion: (() -> Void)! = {}) {
        let baseText = self.titleLabel?.text ?? " "
        DHAnimation.animate(0.2, animations: {
            self.titleLabel?.alpha = 0
        }, withComplection: {
            self.setTitle(text, for: .normal)
            DHAnimation.animate(0.2, animations: {
                self.titleLabel?.alpha = 1
            }, withComplection: {
                DHAnimation.animate(0.2, animations: {
                    self.titleLabel?.alpha = 0
                }, delay: 0.35,
                   withComplection: {
                    self.setTitle(baseText, for: .normal)
                    DHAnimation.animate(0.2, animations: {
                        self.titleLabel?.alpha = 1
                    }, withComplection: {
                        completion()
                    })
                })
            })
        })
    }

    public func setAnimatableText(_ text: String, withComplection completion: (() -> Void)! = {}) {
        DHAnimation.animate(0.3, animations: {
            self.titleLabel?.alpha = 0
        }, withComplection: {
            self.setTitle(text, for: .normal)
            DHAnimation.animate(0.3, animations: {
                self.titleLabel?.alpha = 1
            }, withComplection: {
                completion()
            })
        })
    }

    public func hideContent(completion: (() -> Void)! = {}) {
        DHAnimation.animate(0.25, animations: {
            self.titleLabel?.alpha = 0
        }, withComplection: {
             completion()
        })
    }

    public func showContent(completion: (() -> Void)! = {}) {
        DHAnimation.animate(0.25, animations: {
            self.titleLabel?.alpha = 1
        }, withComplection: {
            completion()
        })
    }
}
