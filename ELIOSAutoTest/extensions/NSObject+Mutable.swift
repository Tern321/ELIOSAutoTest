//
//  NSObject+Mutable.swift
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 09.01.2023.
//

import UIKit

extension NSObject {
    func addObserverForAllProperties(
        observer: NSObject,
        options: NSKeyValueObservingOptions = [],
        context: UnsafeMutableRawPointer? = nil
    ) {
        performForAllKeyPaths { keyPath in
            addObserver(observer, forKeyPath: keyPath, options: options, context: context)
        }
    }

    func removeObserverForAllProperties(
        observer: NSObject,
        context: UnsafeMutableRawPointer? = nil
    ) {
        performForAllKeyPaths { keyPath in
            removeObserver(observer, forKeyPath: keyPath, context: context)
        }
    }

    func performForAllKeyPaths(_ action: (String) -> Void) {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(object_getClass(self), &count) else { return }
        defer { free(properties) }
        for i in 0 ..< Int(count) {
            let keyPath = String(cString: property_getName(properties[i]))
            action(keyPath)
        }
    }
}
