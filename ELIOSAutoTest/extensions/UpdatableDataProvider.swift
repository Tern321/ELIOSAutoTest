//  Created by Evgenii Loshchenko

import UIKit

protocol DataUpdatable {
    func onDataChanged()
}

class UpdatableDataProvider {
    var delegatesContainer = WeakDelegatesContainer<DataUpdatable>()
    
    func addDelegate(delegate: DataUpdatable) {
        delegatesContainer.filterDelegates()
        delegatesContainer.addDelegate(delegate: delegate)
    }
    
    func removeDelegate(delegate: DataUpdatable) {
        delegatesContainer.removeDelegate(delegate: delegate as AnyObject)
        delegatesContainer.filterDelegates()
    }
    
    func sendDataChangedEvent() {
        delegatesContainer.delegates.values.forEach { container in
            container.getValue()?.onDataChanged()
        }
    }
}
