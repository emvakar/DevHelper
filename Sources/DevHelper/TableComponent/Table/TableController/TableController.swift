//
//  TableController.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit
import Foundation

public protocol UITableViewCellIdentifierProvider: class {

    static func getIdentifier() -> String
}

extension UITableViewCell: UITableViewCellIdentifierProvider {

    static public func getIdentifier() -> String {

        return String(describing: self)
    }
}

extension UICollectionViewCell: UITableViewCellIdentifierProvider {

    static public func getIdentifier() -> String {

        return String(describing: self)
    }
}

// MARK: - All business logic in TableController, TableController+Filter, TableController+DataSource
// MARK: - UIViewController
public class TableController: UIViewController {

    // MARK: - Properties
    private var configuration: TableConfiguration!
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentState: TableContentState = .success
    private var processState: TableProcessState = .stopped
    private var searchBarView: UIView! = nil
    public var toolbarView: TableToToolbarProtocol?

    // MARK: - Properties views
    public var refreshControl: UIRefreshControl! = nil
    public var footerView: TableFooterContainerProtocol! = nil
    public var toolbar: UIToolbar?
    public var searchBar: UISearchBar? {
        didSet {
            self.searchBar?.delegate = self.delegateSearch
        }
    }

    // MARK: - Properties to fix refresh
    private var isPullToRefreshing: Bool = false

    // MARK: - Properties to get views
    public weak var viewProtocol: TableToViewControllerProtocol?

    public weak var delegateSearch: UISearchBarDelegate? {
        didSet {
            self.searchBar?.delegate = self.delegateSearch
        }
    }
    // MARK: - Custom setters
    public weak var delegateDataSource: TableControllerDelegate? {
        didSet {
            self.tableView?.delegate = self.delegateDataSource
            self.tableView?.dataSource = self.delegateDataSource
        }
    }
    public var tableView: UITableView! {
        didSet {
            self.tableView?.delegate = self.delegateDataSource
            self.tableView?.dataSource = self.delegateDataSource
        }
    }

    // MARK: - Default init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Custom init
    public init(configuration: TableConfiguration) {

        super.init(nibName: nil, bundle: nil)
        if let copy = configuration.copy() as? TableConfiguration {
            self.configuration = copy
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.addObservers()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createContentObserver()
        self.scrollViewWillAppear()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.contentOffsetObservation != nil {
            self.contentOffsetObservation?.invalidate()
            self.contentOffsetObservation = nil
        }
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scrollViewDidDisappear()
    }
}

// MARK: - Applciation Observers (Home)
extension TableController {

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func applicationDidBecomeActive() {
        self.viewWillAppear(true)
    }

    @objc func applicationWillResignActive() {
        self.viewDidDisappear(true)
    }
}

// MARK: - Private methods
extension TableController {

    //Если сделать Pull-To-Refresh перейти в другой контроллер и вернуться (Если есть UISegmentControl), то UIRefreshControl фризится
    private func scrollViewWillAppear() {
        guard self.configuration.tableOptions.contains(.refreshControl) else { return }

        if self.isPullToRefreshing == true {
            self.refreshControl.beginRefreshing()
            self.tableView.contentOffset.y = -self.refreshControl.frame.size.height
            self.isPullToRefreshing = false
        } else {
            self.refreshControl.endRefreshing()
            if self.tableView.contentOffset.y < 0 {
                self.tableView.contentOffset.y = 0
            }
        }
    }

    //Если сделать Pull-To-Refresh перейти в другой контроллер и вернуться (Если есть UISegmentControl), то UIRefreshControl фризится
    private func scrollViewDidDisappear() {
        guard self.configuration.tableOptions.contains(.refreshControl) else { return }

        if self.refreshControl.isRefreshing {
            self.isPullToRefreshing = true
            self.refreshControl.endRefreshing()
        } else {
            self.isPullToRefreshing = false
        }
    }

    //TableFooter
    private func setTableFooterAndEnableRefreshControl(enableRefresh: Bool, contentState: TableFooterType) {
        if self.footerView != nil {
            self.footerView.displayState(contentState)
        }
        enableRefresh ? self.enableRefreshControl() : self.disableRefreshControl()
    }

    //FetchNext
    private func fetchNextPage(_ shouldCallFetchNextPageDelegate: Bool = true) {
        //Если уже идет какая-то загрузка ничего не делается
        if self.processState != .loading && self.contentState != .endFetching {
            self.processState = .loading

            //Если успешно прогрузили предыдущую страницу показываем лоадер следующей страницы
            if self.contentState == .success {
                if self.footerView != nil {
                    self.footerView.displayState(.loader)
                }
            }

            //Блочим рефреш контрол на время загрузки след. страницы, что бы не было кучи загрузок
            self.disableRefreshControl()

            //Если нужно было показать футер с лоудером и вызвать метода делегата
            if shouldCallFetchNextPageDelegate {
                self.delegateDataSource?.tableControllerRequestsNextPage(self)
            }
        }
    }

    //Get empty table space
    private func tableContentDifference() -> CGFloat {
        let contentSize = self.tableView.contentSize.height
        let frameSize = self.tableView.frame.size.height
        let difference = contentSize - frameSize

        return difference
    }
}

// MARK: - Actions
extension TableController {

    //PullToRefreshAction
    @objc private func pullToRefreshAction(_ refreshControl: UIRefreshControl) {
        //Если уже идет какая-то загрузка ничего не делается
        if self.processState != .loading {
            self.processState = .loading
            self.delegateDataSource?.tableControllerRequestsPullToRefresh(self)
        }
    }
}

// MARK: - Cells
extension TableController {

    public func dequeueCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let reuseIdentifier = T.getIdentifier()
        return self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }

    public func dequeueCell(type: UITableViewCellIdentifierProvider.Type, indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = type.getIdentifier()
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - Public Start/Stop loading
extension TableController {

    //Показать футер с лоудером
    public func startLoading() {

        self.startLoadingView()
        self.fetchNextPage(false)
    }

    //Останавливаем все загрузки, отображаем по статусу вьюшки
    public func stopLoading(state: TableContentState) {
        self.isPullToRefreshing = false

        //Останавливаем загрузку во вьюшках, если она где-то есть
        self.stopLoadingView()
        self.contentState = state

        switch self.contentState {

        //Если успешно загрузилось или постраничная загрузка вся пройдена, показываем пустой футер
        case .success, .endFetching:
            self.setTableFooterAndEnableRefreshControl(enableRefresh: true, contentState: .empty)

        //Пришел пустой список данных
        case .noContent:
            self.setTableFooterAndEnableRefreshControl(enableRefresh: false, contentState: .noContent)

        //Пришла ошибка на загрузку данных
        case .failedLoaded:
            self.setTableFooterAndEnableRefreshControl(enableRefresh: false, contentState: .error)

        //Пришла ошибка на загрузку след странцы данных
        case .failedNextPageLoaded:
            self.setTableFooterAndEnableRefreshControl(enableRefresh: true, contentState: .nextPageError)
            //            self.tableView.scrollRectToVisible((self.tableView.tableFooterView?.frame)!, animated: true)
        }

        //Останавливается процесс загрузки, после обновления всех вьюшек и тд, загрузка следующей страницы, если первая страница занимает часть экрана
        self.processState = .stopped
        if self.tableContentDifference() < 0 && self.contentState == .success && self.configuration.tableOptions.contains(.paged) {
            self.fetchNextPage()
        }
    }

    private func startLoadingView() {
        if self.footerView != nil {
            self.footerView.displayActivity(true)
        }
    }

    private func stopLoadingView() {
        if self.refreshControl != nil {
            self.refreshControl.endRefreshing()
        }

        if self.footerView != nil {
            self.footerView.displayActivity(false)
        }
    }
}

// MARK: - Create UI
extension TableController {

    //Create UI
    private func createUI() {
        self.createSearchBar()
        self.createToolBar()
        self.createTableView()
        self.createFooterViews()

        self.enableRefreshControl()
    }

    //SearchBar
    private func createSearchBar() {
        if self.configuration.tableOptions.contains(.searchBar) {
            if let tuple = self.viewProtocol?.getSearchBarView() {

                self.searchBar = tuple.searchBar
                self.searchBarView = tuple.viewForLayout
                self.view.addSubview(self.searchBarView)

                self.searchBarView.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.left.equalToSuperview()
                    $0.right.equalToSuperview()
                    $0.height.greaterThanOrEqualTo(44)
                }
            }
        }
    }

    //ToolBar
    private func createToolBar() {
        if self.configuration.tableOptions.contains(.toolBar) {
            if let tuple = self.viewProtocol?.getToolbarView(), let viewForLayout = tuple.viewForLayout as? UIView {

                self.toolbar = tuple.toolbar
                self.toolbarView = tuple.viewForLayout

                self.view.addSubview(viewForLayout)
                viewForLayout.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.left.equalToSuperview()
                    $0.right.equalToSuperview()
                    $0.height.greaterThanOrEqualTo(44)
                }
            }
        }
    }

    //Table and cells
    private func createTableView() {
        self.tableView = UITableView()
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)

        self.configuration.cellClasses.forEach { cellClass in

            guard let casted = cellClass.self as? UITableViewCell.Type else {

                return
            }
            let reuseIdentifier = casted.getIdentifier()
            self.tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }

        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchBarView == nil ? self.view : self.searchBarView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            if let toolbarView = self.toolbarView as? UIView {

                $0.bottom.equalTo(toolbarView.snp.top)
            } else {

                $0.bottom.equalTo(self.view)
            }
        }
    }

    //Table footer view
    private func createFooterViews() {
        if let footerView = self.viewProtocol?.getFooterView() {
            footerView.delegate = self
            self.footerView = footerView
        }
    }
}

// MARK: - Filter to Table
extension TableController: FilterToTable {

    public func didClickFilterNotificationClose() {
        self.toolbarView?.hideOverview(animation: true)

        self.delegateDataSource?.tableControllerRequestsCloseNotification(self, completion: { (flag) in
            if flag == true {
                self.contentState = .success
                if self.footerView != nil {
                    self.footerView.displayState(.loader)
                }
                self.fetchNextPage()
            }
        })
    }
}

// MARK: - FooterErrorViews to Table
extension TableController: TableFooterDelegate {

    public func footerViewDidChangeFrame(_ view: TableFooterProtocol) {
        self.tableView.tableFooterView = view as? UIView
    }

    public func fetchNextPageFromView(_ view: TableFooterProtocol) {
        //Если нажали на футере (.noContent, .failed) кнопки одновить страницу и уже удет какая-то загрузка, то останавливаем лоадер на футере
        if self.processState != .loading {
            self.fetchNextPage()
        }
    }
}

// MARK: - Fetch next page when scrolling
extension TableController {
    private func createContentObserver() {
        if self.configuration.tableOptions.contains(.paged) && self.contentOffsetObservation == nil {

            self.contentOffsetObservation = self.tableView.observe(\.contentOffset, options: [.new], changeHandler: { (_, change) in

                //Если не идет никакая загрузка, и удалось загрузить предыдущую страницу, загружаем следующую и пролистнули до низу -- пытаемся загрузить следю страницу
                if let offset = change.newValue?.y {
                    let flag = (offset > self.tableContentDifference()) ? true : false

                    if flag && self.contentState == .success && self.processState == .stopped {
                        self.fetchNextPage()
                    }
                }
            })
        }
    }
}

// MARK: - Refresh control
extension TableController {

    private func enableRefreshControl() {
        if self.configuration.tableOptions.contains(.refreshControl) {
            if self.refreshControl == nil {
                self.refreshControl = UIRefreshControl()
                self.refreshControl.addTarget(self, action: #selector(TableController.pullToRefreshAction(_:)), for: UIControl.Event.valueChanged)
                self.refreshControl.tintColor = UIColor.lightGray
            }
            self.tableView.refreshControl = self.refreshControl
        }
    }

    private func disableRefreshControl() {
        self.tableView.refreshControl = nil
    }
}

// MARK: - DataSourceClientProtocol
extension TableController: DataSourceClient {
    public func updateWithModel(model: ModelTableUpdate) {

        func reload(block: @escaping() -> Void) {
            CATransaction.begin()

            CATransaction.setCompletionBlock { self.delegateDataSource?.tableControllerAnimationComplete(self) }

            block()

            CATransaction.commit()
        }

        switch model.updateType {
        case .reset:
            self.stopLoadingView()
            self.footerView.displayState(.loader)

            reload { self.tableView.reloadData() }

        case .reload:

            reload { self.tableView.reloadData() }

        case .update:
            let values = model.params!

            reload {
                self.tableView.beginUpdates()
                self.tableView.insertSections(values.sectionsInsert, with: .fade)
                self.tableView.deleteSections(values.sectionsDelete, with: .fade)
                self.tableView.reloadSections(values.sectionsUpdate, with: .fade)
                self.tableView.insertRows(at: values.rowsInsert, with: .fade)
                self.tableView.deleteRows(at: values.rowsDelete, with: .fade)
                self.tableView.reloadRows(at: values.rowsUpdate, with: .fade)
                self.tableView.endUpdates()
            }
        }
    }
}
