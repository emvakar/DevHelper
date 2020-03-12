//
//  TableViewModel.swift
//  DevHelper
//
//  Created by Emil Karimov on 05/04/2019.
//  Copyright © 2019 ESKARIA Corp. All rights reserved.
//

import Foundation
import DeepDiff

public enum ModelTableUpdateType {
    case reset
    case reload
    case update
}

public struct ModelTableUpdateParams {

    public var sectionsInsert: IndexSet
    public var sectionsDelete: IndexSet
    public var sectionsUpdate: IndexSet

    public var rowsInsert: [IndexPath]
    public var rowsDelete: [IndexPath]
    public var rowsUpdate: [IndexPath]

    public static func getEmpty() -> ModelTableUpdateParams {
        return ModelTableUpdateParams(sectionsInsert: IndexSet(), sectionsDelete: IndexSet(), sectionsUpdate: IndexSet(), rowsInsert: [IndexPath](), rowsDelete: [IndexPath](), rowsUpdate: [IndexPath]())
    }
}

public struct ModelTableUpdate {

    var updateType: ModelTableUpdateType
    var params: ModelTableUpdateParams?

    public init(updateType: ModelTableUpdateType, params: ModelTableUpdateParams? = nil) {
        if updateType == .update && params == nil {
            fatalError(String("ModelTableUpdateType of type .update must include params"))
        }
        self.updateType = updateType
        self.params = params
    }
}

public protocol DataSourceClient: class {
    func updateWithModel(model: ModelTableUpdate)
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}
