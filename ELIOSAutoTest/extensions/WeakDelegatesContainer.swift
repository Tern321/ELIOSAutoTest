import UIKit

protocol ObjectDeletedProtocol: AnyObject {
    func objectDeleted(memAddress: String)
}

class WeakAssociatedObject {
    
    private var key: UInt8 = 0
    private var targetMemAddress: String
    private weak var delegate: ObjectDeletedProtocol?
    
    init(target: AnyObject, delegate: ObjectDeletedProtocol) {
        self.delegate = delegate
        targetMemAddress = String.memoryAddress(obj: target)
        objc_setAssociatedObject(target, &key, self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

    static func watch(_ target: AnyObject?, delegate: ObjectDeletedProtocol) {
        if let target = target {
            _ = WeakAssociatedObject(target: target, delegate: delegate)
        }
    }

    deinit {
        self.delegate?.objectDeleted(memAddress: self.targetMemAddress)
    }
}

class WeakReferenseContainer<T>: Hashable {
    private weak var value: AnyObject?
    private var _targetMemAddress: String
    
    init(_ value: T) {
        self.value = value as AnyObject
        _targetMemAddress = String.memoryAddress(obj: value as AnyObject)
    }
    
    func targetMemAddress() -> String {
        return _targetMemAddress
    }
    func setValue(_ value: T?) {
        self.value = value as AnyObject
        _targetMemAddress = String.memoryAddress(obj: value as AnyObject)
    }
    
    func getValue() -> T? {
        return value as? T
    }
    
    static func == (lhs: WeakReferenseContainer, rhs: WeakReferenseContainer) -> Bool {
        return lhs._targetMemAddress == rhs._targetMemAddress
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self._targetMemAddress)
    }
}

extension String {
    public static func memoryAddress(obj: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(obj).toOpaque())"
    }
}

class WeakDelegatesContainer<T> : ObjectDeletedProtocol {
    
    var delegates = [String: WeakReferenseContainer<T>]()

    func dropDelegates() {
//        AppDelegate.checkMainThread()
        delegates = [String: WeakReferenseContainer<T>]()
    }
    
    func addDelegate(delegate: T) {
//        AppDelegate.checkMainThread()
        WeakAssociatedObject.watch(delegate as AnyObject, delegate: self)
        let memAddress = String.memoryAddress(obj: delegate as AnyObject)
        delegates[memAddress] = WeakReferenseContainer(delegate)
//        print("addDelegate \(memAddress)")
    }
    
    func removeDelegate(delegate: AnyObject) {
//        AppDelegate.checkMainThread()
        let memAddress = String.memoryAddress(obj: delegate)
        delegates[memAddress] = nil
//        print("objectDeleted \(memAddress)")
    }
    
    func objectDeleted(memAddress: String) {
//        AppDelegate.checkMainThread()
//        print("objectDeleted \(memAddress)")
        delegates[memAddress] = nil
    }
}
