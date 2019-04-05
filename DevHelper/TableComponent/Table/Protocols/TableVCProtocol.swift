//
//  TableVCProtocol.swift
//  DevHelper
//
//  Created by Emil Karimov on 29.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - Table->Parent VC
public protocol TableControllerDelegate: UITableViewDelegate, UITableViewDataSource {
    func tableControllerRequestsPullToRefresh(_ tableController: TableController)
    func tableControllerRequestsNextPage(_ tableController: TableController)
    func tableControllerRequestsCloseNotification(_ tableController: TableController, completion: (_ result: Bool) -> Void)
    func tableControllerAnimationComplete(_ tableController: TableController)
}

// MARK: - Table->ViewController
public protocol TableToViewControllerProtocol: class {
    func getSearchBarView() -> (searchBar: UISearchBar, viewForLayout: UIView)
    func getToolbarView() -> (toolbar: UIToolbar, viewForLayout: TableToToolbarProtocol)
    func getFooterView() -> TableFooterContainerProtocol
}

// MARK: - Default realization TableControllerDelegate
public extension TableControllerDelegate {
    func tableControllerRequestsPullToRefresh(_ tableController: TableController) { }

    func tableControllerRequestsNextPage(_ tableController: TableController) { }

    func tableControllerRequestsCloseNotification(_ tableController: TableController, completion: (_ result: Bool) -> Void) {
        completion(false)
    }

    func tableControllerAnimationComplete(_ tableController: TableController) { }
}

// MARK: - Default footer TableToViewControllerProtocol
public extension TableToViewControllerProtocol {

    func getSearchBarView() -> (searchBar: UISearchBar, viewForLayout: UIView) {
        var searchConfig = SearchBarViewContent()
        searchConfig.background = UIColor.appMainColor()
        searchConfig.fieldBackground = UIColor.white.withAlphaComponent(0.5)
        searchConfig.cancelImage = InterfaceImageProvider.getImage("clear")

        let searchBar = SearchBarView(searchBarViewContent: searchConfig)

        return (searchBar, searchBar)
    }

    //Default TableFooterContainer
    func getFooterView() -> TableFooterContainerProtocol {
        return TableFooterContainerView()
    }

    //Default TableToolBar
    func getToolbarView() -> (toolbar: UIToolbar, viewForLayout: TableToToolbarProtocol) {
        let toolbarView = ToolbarView()
        return (toolbarView.filterToolbar, toolbarView)
    }
}
