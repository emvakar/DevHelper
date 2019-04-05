//
//  TableControllerProtocols+ErrorView.swift
//  DevHelper
//
//  Created by Emil Karimov on 29.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - FooterErrorView->Table

public protocol TableFooterDelegate: class {
    func fetchNextPageFromView(_ view: TableFooterProtocol)
    func footerViewDidChangeFrame(_ view: TableFooterProtocol)
}

// MARK: - Table->FooterErrorView
public protocol TableFooterProtocol: class {

    func displayActivity(_ inProgress: Bool)
}

public enum TableFooterType {
    case empty
    case loader
    case noContent
    case error
    case nextPageError
}

public protocol TableFooterContainerProtocol: TableFooterProtocol {

    var delegate: TableFooterDelegate? { get set }
    func displayState(_ contentState: TableFooterType)
}
