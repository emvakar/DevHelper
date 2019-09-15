//
//  IDataSource.swift
//  DevHelper
//
//  Created by Emil Karimov on 15.05.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import Foundation

public protocol DataSource {
    associatedtype T

    func setClient(_ client: DataSourceClient)
    func getTitle(for section: Int) -> String?
    func numberOfSections() -> Int
    func numberOfRowsInSection(indexOfSection: Int) -> Int
    func getModelAtIndexPath(indexPath: IndexPath) -> T
    func removeModels(animated: Bool)
    func insertModels(models: [T], animated: Bool)
    func updateModels(models: [T], animated: Bool)
    func deleteModelAtIndexPaths(indexPaths: [IndexPath], animated: Bool)

    func compareUnknownType(a: Any, b: Any) -> Bool
}

extension DataSource {

    public func compareUnknownType(a: Any, b: Any) -> Bool {

        if let va = a as? Int, let vb = b as? Int {return va > vb} else if let va = a as? String, let vb = b as? String {return va > vb} else if let va = a as? Date, let vb = b as? Date {return va > vb} else if let va = a as? Double, let vb = b as? Double {return va > vb} else if let va = a as? Float, let vb = b as? Float {return va > vb} else {

            fatalError("tried to compare unsupported type")
        }
    }
}
