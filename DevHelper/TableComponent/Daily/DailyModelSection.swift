//
//  DailyModelSection.swift
//  DevHelper
//
//  Created by Emil Karimov on 05/04/2019.
//  Copyright © 2019 ESKARIA Corp. All rights reserved.
//

import UIKit

public class DailyModelSection<T: Equatable> {

    public var items = Array<T>()
    public var date: Date

    public init(date: Date) {
        self.date = date
    }

    public func addItem(item: T) {
        self.items.append(item)
    }

    public func getItemsCount() -> Int {
        return self.items.count
    }

    public func getItemAtIndex(index: Int) -> T {
        return self.items[index]
    }

    public func getIndexForModel(_ model: T) -> Int? {
        return self.items.index(where: { $0 == model })
    }

    public func removeItemAt(_ index: Int) {
        self.items.remove(at: index)
    }

    public func setItems(_ newItems: [T]) {
        self.items = newItems
    }

    public func getItems() -> [T] {
        return self.items
    }

    public func replaceItemAt(index: Int, item: T) {
        self.items[index] = item
    }
}
