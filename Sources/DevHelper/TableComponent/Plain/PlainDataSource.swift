//
//  PlainDataSource.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.12.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

// MARK: - PlainModelProtocol
public protocol PlainModelProtocol: Equatable {
    func getUniqueId() -> AnyHashable?
}

// MARK: - PlainDataSource
public class PlainDataSource<Template: PlainModelProtocol>: DataSource {

    // MARK: - properties
    var section = PlainModelSection<T>(title: nil)

    public weak var client: DataSourceClient?

    // MARK: - Init
    public init(title: String? = nil) {
        self.section = PlainModelSection<T>(title: title)
    }

    // MARK: - DataSource
    public func setClient(_ client: DataSourceClient) {
        self.client = client
    }

    public func getTitle(for section: Int) -> String? {
        return self.section.title
    }

    public func numberOfSections() -> Int {
        return self.section.getItemsCount() == 0 ? 0 : 1
    }

    public func numberOfRowsInSection(indexOfSection: Int) -> Int {
        return self.section.getItemsCount()
    }

    public func getModelAtIndexPath(indexPath: IndexPath) -> Template {
        return self.section.getItemAtIndex(index: indexPath.row)
    }

    public func getIndexPathForModel(_ model: Template) -> Int? {
        return self.section.getIndexForModel(model)
    }
}

// MARK: - Delete
extension PlainDataSource {

    public func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool) {
        let deletedSectionIndex = NSMutableIndexSet()
        let deletedItemsIndexes = indexPaths

        if indexPaths.isEmpty || self.numberOfSections() == 0 || self.numberOfRowsInSection(indexOfSection: 0) == 0 {
            return
        }

        var sectionsCopy = self.section.getItems()
        for indexPath in indexPaths {
            let deletedModel = self.section.getItemAtIndex(index: indexPath.row)
            let index = sectionsCopy.firstIndex(of: deletedModel)
            sectionsCopy.remove(at: index!)
        }
        self.section.setItems(sectionsCopy)

        if self.section.getItemsCount() == 0 {
            deletedSectionIndex.add(0)
        }

        var updateParams = ModelTableUpdateParams.getEmpty()
        updateParams.sectionsDelete = deletedSectionIndex as IndexSet
        updateParams.rowsDelete = deletedItemsIndexes

        let updateModel = animated ? ModelTableUpdate(updateType: .update, params: updateParams) : ModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }

    func deleteIndexPathsOfModels(models: [Template], animated: Bool) {
        var deletedItemsIndexes: [IndexPath] = []

        for model in models {
            if let row = self.section.getIndexForModel(model) {
                deletedItemsIndexes.append(IndexPath(row: row, section: 0))
            }
        }

        self.deleteModelAtIndexPaths(indexPaths: deletedItemsIndexes, animated: animated)
    }

    public func removeModels(animated: Bool) {
        self.deleteIndexPathsOfModels(models: self.section.getItems(), animated: false)
    }
}

// MARK: - Insert
extension PlainDataSource {

    public func insertModels(models: [Template], animated: Bool) {
        let insertedSectionIndex = NSMutableIndexSet()
        var insertedItemsIndexes: [IndexPath] = []

        if models.isEmpty {
            return
        }

        if self.section.getItemsCount() == 0 && self.numberOfSections() == 0 {
            insertedSectionIndex.add(0)
        }

        for model in models {
            if self.section.getItems().contains(where: { model == $0 }) {
                continue
            }
            insertedItemsIndexes.append(IndexPath(row: self.section.getItemsCount(), section: 0))
            self.section.addItem(item: model)
        }

        var updateParams = ModelTableUpdateParams.getEmpty()
        updateParams.sectionsInsert = insertedSectionIndex as IndexSet
        updateParams.rowsInsert = insertedItemsIndexes

        let updateModel = animated ? ModelTableUpdate(updateType: .update, params: updateParams) : ModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }
}

// MARK: - Update
extension PlainDataSource {

    public func updateModels(models: [Template], animated: Bool, compare: (Template, Template) -> Bool) {

        var updatedItemsIndexes: [IndexPath] = []
        let insertedSectionIndex = NSMutableIndexSet()
        let deletedSectionIndex = NSMutableIndexSet()
        var insertedItemsIndexes: [IndexPath] = []
        var deletedItemsIndexes: [IndexPath] = []

        if self.section.getItemsCount() == 0 && self.numberOfSections() == 0 && !models.isEmpty {
            insertedSectionIndex.add(0)
        }

        let combinations = self.section.getItems().flatMap { firstElement in (firstElement, models.first { secondElement in compare(firstElement, secondElement) }) }
        let common = combinations.filter { $0.1 != nil }.flatMap { ($0.0, $0.1!) }
        let removed = combinations.filter { $0.1 == nil }.flatMap { ($0.0) }
        let inserted = models.filter { secondElement in !common.contains { compare($0.0, secondElement) } }

        for model in models {
            if let index = self.section.getIndexForModel(model) {
                updatedItemsIndexes.append(IndexPath(row: index, section: 0))
            }
        }

        for model in inserted {
            insertedItemsIndexes.append(IndexPath(row: self.section.getItemsCount(), section: 0))
            self.section.addItem(item: model)
        }

        for model in removed {
            if let row = self.section.getIndexForModel(model) {
                deletedItemsIndexes.append(IndexPath(row: row, section: 0))
            }
        }

        var sectionsCopy = self.section.getItems()
        for indexPath in deletedItemsIndexes {
            let deletedModel = self.section.getItemAtIndex(index: indexPath.row)
            if let index = sectionsCopy.firstIndex(of: deletedModel) {
                sectionsCopy.remove(at: index)
            }
        }
        self.section.setItems(sectionsCopy)

        if self.section.getItemsCount() == 0 && self.numberOfSections() == 0 && !models.isEmpty {
//            deletedSectionIndex.add(0)
        }

        var updateParams = ModelTableUpdateParams.getEmpty()
        updateParams.sectionsInsert = insertedSectionIndex as IndexSet
        updateParams.rowsInsert = insertedItemsIndexes
        updateParams.rowsUpdate = updatedItemsIndexes
        updateParams.rowsDelete = deletedItemsIndexes
//        updateParams.sectionsDelete = deletedSectionIndex as IndexSet

        let updateModel = animated ? ModelTableUpdate(updateType: .update, params: updateParams) : ModelTableUpdate(updateType: .reload)
        self.client?.updateWithModel(model: updateModel)
    }

    func updateModelsByIndexPaths(indexPaths: [IndexPath], animated: Bool) {

        var models = [Template]()

        for indexPath in indexPaths {
            let model = self.section.getItemAtIndex(index: indexPath.row)
            models.append(model)
        }

        self.updateModels(models: models, animated: animated, compare: ==)
    }
}
