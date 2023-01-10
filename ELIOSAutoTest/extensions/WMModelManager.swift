//  Created by Evgenii Loshchenko

import UIKit

protocol MyEncodable: Encodable {
    func toJSONData() -> Data?
}

class WMModelManager: NSObject {
    static var modelObjectsList = [WMWeakReferenseContainer<WMModelManager>]()
    override init() {
        super.init()
//        WMLogsManager.log("init model object \(String(describing: self)) \(String.memoryAddress(obj: self))")
        WMModelManager.modelObjectsList.append(WMWeakReferenseContainer(self))
    }
}
