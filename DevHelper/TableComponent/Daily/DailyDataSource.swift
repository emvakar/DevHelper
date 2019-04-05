//
//  DailyDataSource.swift
//  DevHelper
//
//  Created by Emil Karimov on 20/11/2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

public protocol DailyModelProtocol: Equatable {

    func getUniqueId() -> AnyHashable?
    func getDate() -> Date
}

public class DailyDataSource<T: DailyModelProtocol>: DataSource {

    public var uniqueKeys = Set<AnyHashable>()
    public var sections = [DailyModelSection<T>]()
    public var useUtc: Bool = false
    public var selectedItems = [T]()

    public weak var client: DataSourceClient?

    private var isDescOrder: Bool

    private let queue: DispatchQueue

    public init(isDescOrder: Bool) {

        let queue = DispatchQueue(label: "swiftDailyDataSource")
        self.queue = queue
        self.isDescOrder = isDescOrder
    }

    public func updateDescOrder(_ isDescOrder: Bool, animated: Bool, completionBlock: (() -> Void)?) {
        if self.sections.isEmpty || self.isDescOrder == isDescOrder { return }

        self.isDescOrder = isDescOrder
        var models = [T]()
        self.sections.forEach { models.append(contentsOf: $0.getItems()) }
        self.removeModels(animated: false)
        self.insertModels(models: models, animated: animated, completionBlock: completionBlock)
    }

    //Public methods
    public func setClient(_ client: DataSourceClient) {

        self.client = client
    }

    public func getTitle(for section: Int) -> String? {

        return self.sections[section].date.toString(format: .standard)
    }

    public func numberOfSections() -> Int {
        return self.sections.count
    }

    public func numberOfRowsInSection(indexOfSection: Int) -> Int {
        return self.sections[indexOfSection].getItemsCount()
    }

    public func getModelAtIndexPath(indexPath: IndexPath) -> T {
        let section = self.sections[indexPath.section]
        return section.getItemAtIndex(index: indexPath.row)
    }

    public func getSelectedItems() -> [T] {
        return selectedItems
    }

    public func getAllItems() -> [T] {
        var itemsArray = [T]()

        sections.forEach { (section) in
            let itemsInSection = section.getItems()
            itemsArray.append(contentsOf: itemsInSection)
        }

        return itemsArray
    }

    public func getIndexPathFor(model: T) -> IndexPath? {
        for (indexSection, section) in sections.enumerated() {
            if let index = section.getIndexForModel(model) {
                return IndexPath.init(row: index, section: indexSection)
            }
        }

        return nil
    }

    // MARK: - Private methods
    private func roundedDateForModel(_ model: T, useUtc: Bool = true) -> Date? {

        let date = model.getDate()
        var calendar = Calendar.current
        if useUtc, let timeZone = TimeZone(abbreviation: "UTC") {

            calendar.timeZone = timeZone
        } else {

            calendar.timeZone = TimeZone.current
        }

        var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        dateComponents.second = 0
        dateComponents.minute = 0
        dateComponents.hour = 0

        return calendar.date(from: dateComponents)
    }

    private func getIndexPathForModel(_ model: T) -> IndexPath {
        for (indexSection, section) in sections.enumerated() {
            if let index = section.getIndexForModel(model) {
                return IndexPath.init(row: index, section: indexSection)
            }
        }

        return IndexPath.init(row: 0, section: 0)
    }

    private func insertModels(models: [T], animated: Bool, replacingOldModels: Bool, completionBlock: (() -> Void)?) {

        // Both animated insert with replacingOldModels is not supported

        if self.sections.isEmpty && models.isEmpty {
            DispatchQueue.main.sync {
                let modelUpdate = ModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: modelUpdate)
            }
            return
        }

        var updateParams = ModelTableUpdateParams.getEmpty()
        var insertedSections = [DailyModelSection<T>]()
        var trackedModels = [T]()
        var sectionsCopy = replacingOldModels ? [] : self.sections
        var existingUniqueKeys: Set<AnyHashable> = replacingOldModels ? Set<AnyHashable>(): self.uniqueKeys

        // Отсортировать модели которые пришли, отсеиваются с пустым идентификатором и уже имеющеся
        let sortedModels = (models.filter {
            if let uniqueKey = $0.getUniqueId(), !existingUniqueKeys.contains(uniqueKey) {
                existingUniqueKeys.insert(uniqueKey)
                return true
            }
            return false
        }).sorted { self.isDescOrder ? $0.getDate() > $1.getDate(): $0.getDate() < $1.getDate() }

        // split models in sections
        for model in sortedModels {
            guard let date = self.roundedDateForModel(model, useUtc: self.useUtc) else { continue }

            if let section = sectionsCopy.first(where: { $0.date == date }) {
                section.addItem(item: model)
            } else {
                let newSection = DailyModelSection<T>(date: date)
                newSection.addItem(item: model)
                sectionsCopy.append(newSection)
                insertedSections.append(newSection)
            }

            if !insertedSections.contains(where: { $0.date == date }) {
                trackedModels.append(model)
            }
        }

        // sort models in sections
        for section in sectionsCopy {
            section.items = section.items.sorted { self.isDescOrder ? $0.getDate() > $1.getDate(): $0.getDate() < $1.getDate() }
        }

        // sort sections
        sectionsCopy = sectionsCopy.sorted { self.isDescOrder ? $0.date > $1.date: $0.date < $1.date }

        // get indexes of new sections
        let insertedSectionIndexes = NSMutableIndexSet()
        for section in insertedSections {
            if let index = sectionsCopy.firstIndex(where: { $0.date == section.date }) {
                insertedSectionIndexes.add(index)
            }
        }

        // get index paths of new models in old sections
        var insertedItemsIndexes: [IndexPath] = []
        for model in trackedModels {
            guard let date = self.roundedDateForModel(model, useUtc: self.useUtc) else { continue }

            guard let section = sectionsCopy.first(where: { $0.date == date }) else { continue }
            guard let row = section.items.firstIndex(where: { $0 == model }) else { continue }
            guard let sectionNumber = sectionsCopy.firstIndex(where: { $0.date == date }) else { continue }

            let indexPath = IndexPath(row: row, section: sectionNumber)
            insertedItemsIndexes.append(indexPath)
        }

        updateParams.sectionsInsert = insertedSectionIndexes as IndexSet
        updateParams.rowsInsert = insertedItemsIndexes

        DispatchQueue.main.sync {
            self.sections = sectionsCopy
            self.uniqueKeys = existingUniqueKeys
            var updateModel: ModelTableUpdate! = nil
            if animated && !replacingOldModels {
                updateModel = ModelTableUpdate(updateType: .update, params: updateParams)
                self.client?.updateWithModel(model: updateModel)
            } else {
                updateModel = ModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: updateModel)
            }

            completionBlock?()
        }
    }
}

// MARK: - Delete
extension DailyDataSource {

    @available(*, deprecated, message: "Use replaceModels([]) method instead")
    public func removeModels(animated: Bool) {

        self.queue.async {

            if animated {

                DispatchQueue.main.sync {
                    self.sections = []
                    self.uniqueKeys = Set<String>()
                    let model = ModelTableUpdate(updateType: .reset)
                    self.client?.updateWithModel(model: model)
                }
            } else {

                self.sections = []
                self.uniqueKeys = Set<String>()
            }
        }
    }

    public func replaceModels(models: [T]) {

        self.queue.async {

            self.insertModels(models: models, animated: false, replacingOldModels: true, completionBlock: nil)
        }
    }
}

// MARK: - Insert
extension DailyDataSource {
    public func insertModels(models: [T], animated: Bool) {
        self.insertModels(models: models, animated: animated, completionBlock: nil)
    }

    public func insertModels(models: [T], animated: Bool, completionBlock: (() -> Void)?) {

        self.queue.async {

            self.insertModels(models: models, animated: animated, replacingOldModels: false, completionBlock: nil)
        }
    }
}

// MARK: - Update
extension DailyDataSource {

    public func updateModel(model: T, animated: Bool) {

        self.queue.async {
            for section in self.sections {
                if let index = section.getIndexForModel(model) {
                    section.replaceItemAt(index: index, item: model)
                }
            }

            let indexPath = self.getIndexPathForModel(model)
            var updateParams = ModelTableUpdateParams.getEmpty()

            updateParams.sectionsUpdate = IndexSet([indexPath.section])
            updateParams.rowsInsert = [indexPath]

            DispatchQueue.main.sync {
                var updateModel: ModelTableUpdate! = nil
                if animated {
                    updateModel = ModelTableUpdate(updateType: .update, params: updateParams)
                    self.client?.updateWithModel(model: updateModel)
                } else {
                    updateModel = ModelTableUpdate(updateType: .reload)
                    self.client?.updateWithModel(model: updateModel)
                }
            }
        }
    }

    public func updateModels(models: [T], animated: Bool) {

        self.queue.async {

            var indexPathsOfModels = [IndexPath]()
            var indexSetOfSections = IndexSet()

            models.forEach { (model) in
                for section in self.sections {
                    if let index = section.getIndexForModel(model) {
                        section.replaceItemAt(index: index, item: model)
                    }
                }

                let indexPath = self.getIndexPathForModel(model)
                indexPathsOfModels.append(indexPath)
                indexSetOfSections.insert(indexPath.section)
            }

            var updateParams = ModelTableUpdateParams.getEmpty()
            updateParams.sectionsUpdate = indexSetOfSections
            updateParams.rowsInsert = indexPathsOfModels

            DispatchQueue.main.sync {
                var updateModel: ModelTableUpdate! = nil
                if animated {
                    updateModel = ModelTableUpdate(updateType: .update, params: updateParams)
                    self.client?.updateWithModel(model: updateModel)
                } else {
                    updateModel = ModelTableUpdate(updateType: .reload)
                    self.client?.updateWithModel(model: updateModel)
                }
            }
        }
    }
}

// MARK: - Delete
extension DailyDataSource {

    public func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool) {

        self.queue.async {

            var deletedSections = IndexSet()
            var deletedIndexes = [IndexPath]()

            // добавили удаляемые ячейки
            deletedIndexes = indexPaths

            //Найдем все удаляемые модели
            var deletedModels = [T]()
            for indexPath in indexPaths {
                let deletedModel = self.sections[indexPath.section].getItemAtIndex(index: indexPath.row)
                deletedModels.append(deletedModel)
            }

            //теперь нужно удалить эти модели из sections и из массива с выделенными ячейками (если удаляем в editing mode)
            for section in self.sections {
                for deletedModel in deletedModels {
                    if let index = section.getIndexForModel(deletedModel) {
                        section.removeItemAt(index)
                    }
                    if let index = self.selectedItems.firstIndex(where: { $0 == deletedModel }) {
                        self.selectedItems.remove(at: index)
                    }
                }
            }

            //находим секции, где нет итемов
            for (sectionIndex, section) in self.sections.enumerated() {
                if section.getItemsCount() == 0 {
                    deletedSections.insert(sectionIndex)
                }
            }

            var indexes = [Int]()
            deletedSections.forEach { (index) in
                indexes.append(index)
            }
            //кастомный remove, так как из массива секций все элементы удалять нужно одновременно
            DispatchQueue.main.sync {

                self.sections.remove(at: indexes)

                var updateParams = ModelTableUpdateParams.getEmpty()
                updateParams.rowsDelete = deletedIndexes
                updateParams.sectionsDelete = deletedSections

                let updateModel = animated ? ModelTableUpdate(updateType: .update, params: updateParams) : ModelTableUpdate(updateType: .reload)
                self.client?.updateWithModel(model: updateModel)
            }
        }
    }

    public func deleteSelectedItems() {

        self.queue.async {
            let selectedItems = self.selectedItems
            var indexPaths = [IndexPath]()

            selectedItems.forEach { (selectedItem) in
                for (sectionIndex, section) in self.sections.enumerated() {
                    if let index = section.getIndexForModel(selectedItem) {
                        let indexPath = IndexPath(row: index, section: sectionIndex)
                        indexPaths.append(indexPath)
                    }
                }
            }

            self.deleteModelAtIndexPaths(indexPaths: indexPaths, animated: true)
        }
    }
}

// MARK: - Selection
extension DailyDataSource {

    //вызывается при нажатии на ячейку при editing mode
    public func selectOrDeselectItem(at indexPath: IndexPath) {

        let section = self.sections[indexPath.section]
        let selectedItem = section.getItemAtIndex(index: indexPath.row)

        guard self.selectedItems.isEmpty == false else {

            self.selectedItems.append(selectedItem)
            return
        }
        if let index = selectedItems.firstIndex(where: { $0 == selectedItem }) {

            self.selectedItems.remove(at: index)
        } else {

            self.selectedItems.append(selectedItem)
        }
    }

    @discardableResult
    public func selectAll() -> [IndexPath] {

        var indexPaths = [IndexPath]()

        for (index, section) in self.sections.enumerated() {
            let items = section.getItems()
            items.forEach({ (item) in

                if !self.selectedItems.contains(where: { $0 == item }) {
                    self.selectedItems.append(item)
                    if let row = section.getIndexForModel(item) {
                        indexPaths.append(IndexPath(row: row, section: index))
                    }
                }
            })
        }

        return indexPaths
    }

    @discardableResult
    public func deselectAll() -> [IndexPath] {
        var indexPaths = [IndexPath]()

        let selectedItems = self.getSelectedItems()
        selectedItems.forEach { (selectedItem) in
            for (index, section) in sections.enumerated() {
                if let row = section.getIndexForModel(selectedItem) {
                    indexPaths.append(IndexPath(row: row, section: index))
                }
            }
        }

        self.selectedItems = []
        return indexPaths
    }
}
