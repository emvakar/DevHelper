//
//  DHLoginInputView.swift
//  Alamofire
//
//  Created by Emil Karimov on 20/06/2019.
//

import UIKit
import SnapKit

public class DHLoginInputView: UIView {
    
    public var imageViewIcon = UIImageView()
    
    public var textField = UITextField()
    private var separator = UIView()
    
    public func setPlaceholder(_ placeHolder: String, textColor: UIColor? = nil) {
        
        if let color = textColor {
            
            let attribute = [NSAttributedString.Key.foregroundColor: color]
            let string = NSAttributedString(string: placeHolder, attributes: attribute)
            self.textField.attributedPlaceholder = string
        } else if let color = self.textField.textColor {
            
            let attribute = [NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.8)]
            let string = NSAttributedString(string: placeHolder, attributes: attribute)
            self.textField.attributedPlaceholder = string
        } else {
            
            self.textField.placeholder = placeHolder
        }
    }

    public convenience init(color: UIColor, keyboardType: UIKeyboardType) {
        
        self.init(frame: .zero)
        self.imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        self.imageViewIcon.contentMode = .center
        self.imageViewIcon.image? = (self.imageViewIcon.image?.withRenderingMode(.alwaysTemplate))!
        self.imageViewIcon.layer.cornerRadius = 34 / 2
        self.imageViewIcon.layer.masksToBounds = true
        self.imageViewIcon.backgroundColor = color
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.font = UIFont.systemFont(ofSize: 17)
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.textAlignment = .left
        
        self.textField.textColor = UIColor.black.withAlphaComponent(0.8)
        self.textField.tintColor = color
        self.textField.keyboardType = .emailAddress
        self.addSubview(self.imageViewIcon)
        self.addSubview(self.textField)
        self.imageViewIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalTo(self.textField)
            make.width.equalTo(34)
            make.height.equalTo(34)
        }
        self.textField.snp.makeConstraints({ (make) in
            make.left.equalTo(self.imageViewIcon.snp.right).offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview()
            make.height.equalTo(46).priority(999)
        })
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color.withAlphaComponent(0.8)
        self.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        self.separator = separator
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DHLoginInputView.click(tapRecognizer:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    public func setImage(_ image: UIImage){
        self.imageViewIcon.image = image
    }
    
    public func setSeparatorColor(_ color: UIColor = UIColor.white) {
        self.separator.backgroundColor = color
    }
    public func setSecureText(_ isSecure: Bool) {
        self.textField.isSecureTextEntry = isSecure
    }
    public func setKeyboardType(type: UIKeyboardType) {
        self.textField.keyboardType = type
    }
    
    public func getTextField() -> UITextField {
        return self.textField
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func click(tapRecognizer: UITapGestureRecognizer) {
        self.textField.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        self.textField.becomeFirstResponder()
        return true
    }
    
    public override var canResignFirstResponder: Bool {
        return true
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

