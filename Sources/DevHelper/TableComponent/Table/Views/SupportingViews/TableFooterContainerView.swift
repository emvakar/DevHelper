//
//  TableFooterContainerView.swift
//  DevHelper
//
//  Created by Emil Karimov on 04.09.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - TableFooterContainerView
open class TableFooterContainerView: UIView {

    // MARK: - Properties
    weak public var delegate: TableFooterDelegate?
    public var loader: BaseFooterView?
    public var noContentCurtain: BaseFooterView?
    public var errorCurtain: BaseFooterView?
    public var pageLoaderErrorView: BaseFooterView?

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience public init(noContentMessage: String, errorMessage: String) {
        let errorView = CurtainView(message: errorMessage)
        let noContentView = CurtainView(message: noContentMessage)
        self.init(noContentCurtain: noContentView, errorCurtain: errorView)
    }

    public init(loader: BaseFooterView? = LoadingView(), noContentCurtain: BaseFooterView? = CurtainView(message: "Нет данных"), errorCurtain: BaseFooterView? = CurtainView(message: "Ошибка загрузки данных"), pageLoaderErrorView: BaseFooterView? = PageLoaderErrorView()) {
        super.init(frame: .zero)

        self.loader = loader
        self.loader?.delegate = self

        self.noContentCurtain = noContentCurtain
        self.noContentCurtain?.delegate = self

        self.errorCurtain = errorCurtain
        self.errorCurtain?.delegate = self

        self.pageLoaderErrorView = pageLoaderErrorView
        self.pageLoaderErrorView?.delegate = self
    }
}

// MARK: - TableFooterContainerProtocol
extension TableFooterContainerView: TableFooterContainerProtocol {

    open func displayActivity(_ inProgress: Bool) {

        self.noContentCurtain?.displayActivity(inProgress)
        self.errorCurtain?.displayActivity(inProgress)
        self.pageLoaderErrorView?.displayActivity(inProgress)
    }

    open func displayState(_ contentState: TableFooterType) {
        for view in self.subviews {
            view.removeFromSuperview()
        }

        switch contentState {
        case .empty:         self.setEmptyView()
        case .loader:        self.setLoadingView()
        case .noContent:     self.setNoContentCurtainView()
        case .error:         self.setErrorCurtainView()
        case .nextPageError: self.setPageErrorFooterView()
        }

        self.delegate?.footerViewDidChangeFrame(self)
    }
}

// MARK: - TableFooterDelegate
extension TableFooterContainerView: TableFooterDelegate {

    public func fetchNextPageFromView(_ view: TableFooterProtocol) {
        self.delegate?.fetchNextPageFromView(self)
    }

    public func footerViewDidChangeFrame(_ view: TableFooterProtocol) {
        self.delegate?.footerViewDidChangeFrame(self)
    }
}

// MARK: - Public methods
extension TableFooterContainerView {

    public func updateNoContentMessage(_ message: String?) {
        if let noContentView = self.noContentCurtain as? CurtainView {
            noContentView.updateMessage(message: message)
        }
    }

    public func updateErrorMessage(_ message: String?) {

        self.updateMessage(in: self.errorCurtain, message: message)
        self.updateMessage(in: self.pageLoaderErrorView, message: message)
    }

    private func updateMessage(in view: UIView?, message: String?) {

        guard let view = view else { return }
        if let casted = view as? CurtainView {

            casted.updateMessage(message: message)
        } else if let casted = view as? PageLoaderErrorView {

            casted.updateMessage(message)
        }
    }
}

// MARK: - Private methods
extension TableFooterContainerView {

    //failed load page view
    private func setPageErrorFooterView() {
        if let loader = self.pageLoaderErrorView {
            loader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: loader.getViewHeight())
            self.frame = loader.frame
            self.addSubview(loader)
        }
    }

    //No content Error
    private func setNoContentCurtainView() {
        if let noContent = self.noContentCurtain {
            noContent.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: noContent.getViewHeight())
            self.frame = noContent.frame
            self.addSubview(noContent)
        }
    }

    //Error view
    private func setErrorCurtainView() {
        if let errorView = self.errorCurtain {
            errorView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: errorView.getViewHeight())
            self.frame = errorView.frame
            self.addSubview(errorView)
        }
    }

    //Loader
    private func setLoadingView() {
        if let loader = self.loader {
            loader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: loader.getViewHeight())
            self.frame = loader.frame
            self.addSubview(loader)
        }
    }

    //Empty footer
    private func setEmptyView() {
        self.frame = .zero
        self.addSubview(UIView())
    }
}
