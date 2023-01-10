//
//  WMWeakReferenseContainer.swift
//  Webim.Ru
//
//  Created by EVGENII Loshchenko on 05.04.2021.
//  Copyright © 2021 _webim_. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class WMWeakReferenseContainer<T>: Hashable {
    private weak var value: AnyObject?

    init(_ value: T) {
        self.value = value as AnyObject
    }
    
    func setValue(_ value: T?) {
        self.value = value as AnyObject
    }
    
    func getValue() -> T? {
        return value as? T
    }
    
    static func == (lhs: WMWeakReferenseContainer, rhs: WMWeakReferenseContainer) -> Bool {
        return ObjectIdentifier(lhs.value ?? lhs) == ObjectIdentifier(rhs.value ?? rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( ObjectIdentifier(value ?? self).hashValue)
    }
}

extension String {
    public static func memoryAddress(obj: AnyObject) -> String {
        return "\(obj.self)"
    }
}

class WeakDelegatesContainer<T> {
    var delegates = [String: WMWeakReferenseContainer<T>]()
    
    func dropDelegates() {
//        AppDelegate.checkMainThread()
        delegates = [String: WMWeakReferenseContainer<T>]()
    }
    
    func addDelegate(delegate: T) {
//        AppDelegate.checkMainThread()
        let memAddress = String.memoryAddress(obj: delegate as AnyObject)
        delegates[memAddress] = WMWeakReferenseContainer(delegate)
    }
    
    func removeDelegate(delegate: AnyObject) {
//        AppDelegate.checkMainThread()
        let memAddress = String.memoryAddress(obj: delegate)
        delegates[memAddress] = nil
    }
    
    func filterDelegates() {
//        AppDelegate.checkMainThread()
        delegates = delegates.filter { _, value in
            return value.getValue() != nil
        }
    }
}
