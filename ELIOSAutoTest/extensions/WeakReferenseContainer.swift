import UIKit

class WeakReferenseContainer<T>: Hashable {
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
    
    static func == (lhs: WeakReferenseContainer, rhs: WeakReferenseContainer) -> Bool {
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
    var delegates = [String: WeakReferenseContainer<T>]()
    
    func dropDelegates() {
//        AppDelegate.checkMainThread()
        delegates = [String: WeakReferenseContainer<T>]()
    }
    
    func addDelegate(delegate: T) {
//        AppDelegate.checkMainThread()
        let memAddress = String.memoryAddress(obj: delegate as AnyObject)
        delegates[memAddress] = WeakReferenseContainer(delegate)
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
