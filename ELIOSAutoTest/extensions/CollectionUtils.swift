//
//  CollectionUtils.swift
//  Webim.Ru
//
//  Created by user on 29/08/2018.
//  Copyright © 2018 _webim_. All rights reserved.
//

import Foundation

extension Sequence {
    func groupBy<G: Hashable>(closure: (Iterator.Element) -> G) -> [G: [Iterator.Element]] {
// swiftlint:disable syntactic_sugar
        var results = [G: Array<Iterator.Element>]()
// swiftlint:enable syntactic_sugar
        forEach {
            let key = closure($0)
            if var array = results[key] {
                array.append($0)
                results[key] = array
            } else {
                results[key] = [$0]
            }
        }
        return results
    }
}

extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}

extension Dictionary where Value: Equatable {
    func containsValue(valueSearch: Value) -> Bool {
        return self.contains(where: { (_, value) in
            value == valueSearch
        })
    }
}

extension Dictionary where Key: Equatable {
    func containsKey(keySearch: Key) -> Bool {
        return self.contains(where: { (key, _) in
            key == keySearch
        })
    }
}

extension Dictionary {
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
}

extension Array where Element: Equatable {
    mutating func remove(element: Element) {
        if let index = self.firstIndex(of: element) {
            remove(at: index)
        }
    }
}

extension Array {
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
}

class WeakRef<Value> where Value: AnyObject {
    
    private weak var _value: Value?
    
    var value: Value? {
        return _value
    }
    
    init(value: Value?) {
        self._value = value
    }
}

protocol Weakly {
    associatedtype Value: AnyObject
    var weak: WeakRef<Value> {
        get
    }
}

extension WeakRef: Weakly {
    var weak: WeakRef<Value> {
        return self
    }
}

extension Array where Element: Weakly {
// swiftlint:disable syntactic_sugar
    func compact() -> Array<Element> {
// swiftlint:enable syntactic_sugar
        return self.filter { $0.weak.value != nil }
    }
}
