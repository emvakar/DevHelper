//
//  PlainModelSection.swift
//  DevHelper
//
//  Created by Emil Karimov on 14.12.2018.
//  Copyright © 2018 ESKARIA Corp. All rights reserved.
//

import UIKit

//MAKR: - PlainModelSection
public class PlainModelSection<T: Equatable> {
    public var items = Array<T>()
    public var title: String?

    public init(title: String?) {
        self.title = title
    }

    public func addItem(item: T) {
        self.items.append(item)
    }

    public func getItemsCount() -> Int {
        return items.count
    }

    public func getItemAtIndex(index: Int) -> T {
        return items[index]
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
