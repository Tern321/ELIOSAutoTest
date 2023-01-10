//  Created by Evgenii Loshchenko

import UIKit

protocol WMDataUpdatable {
    func onDataChanged()
}

class WMUpdatableDataProvider: WMModelManager {
    var delegatesContainer = WeakDelegatesContainer<WMDataUpdatable>()
    
    func addDelegate(delegate: WMDataUpdatable) {
        delegatesContainer.filterDelegates()
        delegatesContainer.addDelegate(delegate: delegate)
    }
    
    func removeDelegate(delegate: WMDataUpdatable) {
        delegatesContainer.removeDelegate(delegate: delegate as AnyObject)
        delegatesContainer.filterDelegates()
    }
    
    func sendDataChangedEvent() {
        delegatesContainer.delegates.values.forEach { container in
            container.getValue()?.onDataChanged()
        }
    }
    
//    func reloadData() { }
}
