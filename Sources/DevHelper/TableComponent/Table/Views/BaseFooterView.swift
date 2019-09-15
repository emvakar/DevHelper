//
//  BaseFooterView.swift
//  DevHelper
//
//  Created by Emil Karimov on 16.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - BaseFooterView
open class BaseFooterView: UIView, TableFooterProtocol {

    // MARK: - Properties
    weak public var delegate: TableFooterDelegate?

    // MARK: - Need to override this method for connecting TableView and ErrorViews
    open func displayActivity(_ inProgress: Bool) { }
    open func getViewHeight() -> CGFloat {
        fatalError("Need to override this method to get height of view")
    }

    // MARK: - Default init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
}
